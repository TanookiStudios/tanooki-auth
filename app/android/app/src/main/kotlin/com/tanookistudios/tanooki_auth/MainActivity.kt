package com.tanookistudios.tanooki_auth

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.wearable.PutDataRequest
import com.google.android.gms.wearable.Wearable
import com.tanookistudios.shared.FavoriteStore

// FragmentActivity is required by local_auth's biometric prompt.
class MainActivity : FlutterFragmentActivity() {
    companion object {
        /** Sent by the Quick Settings tile. Explicit intents only: no other app can open it. */
        const val SCAN_URI = "tanookiauth://scan"
    }

    private var pendingAction: String? = null
    private var extras: MethodChannel? = null

    private fun actionOf(intent: Intent?): String? = when {
        intent?.dataString == SCAN_URI -> "scan"
        intent?.action == Intent.ACTION_VIEW && intent.data?.scheme == "content" -> "share:" + readSharedFile(intent)
        else -> null
    }

    /** The text of a tapped shared-account file. Anything big can't be one, so it's left empty (the app then says so). */
    private fun readSharedFile(intent: Intent): String = try {
        contentResolver.openInputStream(intent.data!!)?.use { input ->
            val buf = ByteArray(64 * 1024 + 1)
            var n = 0
            while (n < buf.size) {
                val r = input.read(buf, n, buf.size - n)
                if (r < 0) break
                n += r
            }
            if (n == buf.size) "" else String(buf, 0, n, Charsets.UTF_8)
        } ?: ""
    } catch (e: Exception) {
        ""
    }

    // Premium app icons: one launcher activity-alias per icon in AndroidManifest.xml, exactly one enabled.
    private val appIconIds = listOf("default", "pink", "blue", "lavender", "mint", "midnight", "sunset")
    private fun iconAlias(id: String) = ComponentName(this, "${MainActivity::class.java.`package`!!.name}.AppIcon_$id")

    private fun currentAppIcon(): String = appIconIds.firstOrNull { id ->
        when (packageManager.getComponentEnabledSetting(iconAlias(id))) {
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED -> true
            PackageManager.COMPONENT_ENABLED_STATE_DEFAULT -> id == "default" // enabled in the manifest
            else -> false
        }
    } ?: "default"

    /** Turns the new icon on before turning the others off, so there is never a moment with no launcher icon.
     *  DONT_KILL_APP keeps the app open; the launcher may drop and re-add the icon for a moment. */
    private fun setAppIcon(id: String) {
        val pm = packageManager
        pm.setComponentEnabledSetting(iconAlias(id), PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP)
        for (other in appIconIds) if (other != id) {
            pm.setComponentEnabledSetting(iconAlias(other), PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        actionOf(intent)?.let {
            pendingAction = it
            extras?.invokeMethod("action", null)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        pendingAction = actionOf(intent)
        // On from the first frame (the default on phones); Settings > Block screenshots can turn it off.
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tanooki/window").setMethodCallHandler { call, result ->
            when (call.method) {
                "setSecure" -> {
                    // Keeps codes out of screenshots, screen recordings and the recent-apps preview.
                    if (call.arguments == true) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        extras = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tanooki/extras").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "setFavorites" -> {
                        val json = call.arguments as String
                        FavoriteStore.save(this@MainActivity, json)
                        FavoritesWidget.updateAll(this@MainActivity)
                        sendToWatch(json)
                        result.success(null)
                    }
                    "takeAction" -> {
                        result.success(pendingAction)
                        pendingAction = null
                    }
                    "getAppIcon" -> result.success(currentAppIcon())
                    "setAppIcon" -> {
                        val id = call.arguments as? String
                        if (id !in appIconIds) {
                            result.error("unknownIcon", null, null)
                        } else {
                            setAppIcon(id!!)
                            android.util.Log.i("TanookiAppIcon", "set: $id, now ${currentAppIcon()}")
                            result.success(null)
                        }
                    }
                    // Test-only (debug builds): the codes the widget would show now, from the widget's own code. Never secrets.
                    "debugWidgetCodes" -> if (applicationInfo.flags and android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE != 0) {
                        val now = System.currentTimeMillis() / 1000
                        result.success(FavoriteStore.load(this@MainActivity).map { listOf(it.title, it.code(now)) })
                    } else {
                        result.notImplemented()
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    /** Hands the favorites (or an empty list) to a paired Wear OS watch. Phones without Google Play services just skip it. */
    private fun sendToWatch(json: String) {
        try {
            val request = PutDataRequest.create("/favorites").setData(json.toByteArray()).setUrgent()
            Wearable.getDataClient(this).putDataItem(request)
        } catch (e: Exception) {
            // No watch support on this phone.
        }
    }
}
