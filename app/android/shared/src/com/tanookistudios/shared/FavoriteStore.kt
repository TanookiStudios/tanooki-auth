package com.tanookistudios.shared

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import org.json.JSONArray
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/** One favorite as the app hands it over (see app/lib/core/widget_share.dart). */
data class Favorite(
    val issuer: String,
    val label: String,
    val secret: String,
    val algorithm: String,
    val digits: Int,
    val period: Int,
    /** "totp" or "steam"; favorites saved before Steam support have none, so default to totp. */
    val type: String = "totp",
    /** The account's own color (0xAARRGGBB) and emoji, when the user picked them. */
    val color: Int? = null,
    val emoji: String? = null,
) {
    val title: String get() = issuer.ifEmpty { label }

    /** The emoji before the name, if any: "🎮 Steam". */
    val badgedTitle: String get() = emoji?.let { "$it $title" } ?: title

    fun code(unixSeconds: Long): String =
        Totp.base32Decode(secret)?.let {
            if (type == "steam") Totp.steam(it, unixSeconds, period) else Totp.totp(it, unixSeconds, period, digits, algorithm)
        } ?: "-".repeat(digits)
}

/**
 * The favorites copy for the widget (phone) or the watch app (Wear OS), encrypted with a key that lives in
 * the Android Keystore and can't leave this device. Only exists while "Show codes on widgets and watch" is
 * on; the app erases it when that is turned off.
 */
object FavoriteStore {
    private const val PREFS = "tanooki_favorites"
    private const val KEY_ALIAS = "tanooki_favorites_key"

    private fun key(): SecretKey {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (ks.getKey(KEY_ALIAS, null) as? SecretKey)?.let { return it }
        return KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore").apply {
            init(
                KeyGenParameterSpec.Builder(KEY_ALIAS, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                    .build()
            )
        }.generateKey()
    }

    /** Replaces the stored list. An empty list (or bad JSON) erases it. */
    fun save(context: Context, json: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        if (parse(json).isEmpty()) {
            prefs.edit().remove("data").commit()
            return
        }
        val cipher = Cipher.getInstance("AES/GCM/NoPadding").apply { init(Cipher.ENCRYPT_MODE, key()) }
        val sealed = cipher.iv + cipher.doFinal(json.toByteArray())
        prefs.edit().putString("data", Base64.encodeToString(sealed, Base64.NO_WRAP)).commit()
    }

    fun load(context: Context): List<Favorite> {
        val stored = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString("data", null) ?: return emptyList()
        return try {
            val sealed = Base64.decode(stored, Base64.NO_WRAP)
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, sealed, 0, 12))
            parse(String(cipher.doFinal(sealed, 12, sealed.size - 12)))
        } catch (e: Exception) {
            emptyList() // key gone (app data cleared) or damaged: show nothing rather than wrong codes
        }
    }

    fun parse(json: String): List<Favorite> = try {
        val arr = JSONArray(json)
        List(arr.length()) { i ->
            val o = arr.getJSONObject(i)
            Favorite(
                o.getString("issuer"), o.getString("label"), o.getString("secret"),
                o.getString("algorithm"), o.getInt("digits"), o.getInt("period"),
                o.optString("type", "totp"),
                if (o.has("color")) o.getLong("color").toInt() else null,
                o.optString("emoji").ifEmpty { null },
            )
        }
    } catch (e: Exception) {
        emptyList()
    }
}
