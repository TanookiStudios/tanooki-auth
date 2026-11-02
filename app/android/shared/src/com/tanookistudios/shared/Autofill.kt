package com.tanookistudios.shared

import android.content.Context
import org.json.JSONArray

/** One account as the app hands it to the autofill service (autofillAccounts in app/lib/core/widget_share.dart). */
data class AutofillAccount(
    val id: String,
    val issuer: String,
    val label: String,
    val secret: String,
    val algorithm: String,
    val digits: Int,
    val period: Int,
    /** "totp" or "steam". */
    val type: String = "totp",
    /** Websites this account signs in to, as the app stores them ("github.com"). */
    val domains: List<String> = emptyList(),
    /** An "ask first" account: the phone asks for fingerprint, face or screen lock before filling it. */
    val requireAuth: Boolean = false,
) {
    val title: String get() = issuer.ifEmpty { label }

    /** What the autofill pop-up says: "GitHub (me)". */
    val suggestionLabel: String get() = if (issuer.isEmpty() || label.isEmpty()) title else "$issuer ($label)"

    /** Null for a broken secret: better no code than a wrong one. */
    fun code(unixSeconds: Long): String? = Totp.base32Decode(secret)?.let {
        if (type == "steam") Totp.steam(it, unixSeconds, period) else Totp.totp(it, unixSeconds, period, digits, algorithm)
    }
}

/** Which accounts fit the website or app asking for a code. Mirrors AutoFillMatch in ios/Shared/AutoFill.swift. */
object AutofillMatch {
    /** Words in app ids that say nothing about the service ("com.github.android" -> "github"). */
    val filler = setOf("com", "org", "net", "io", "co", "app", "apps", "android", "ios", "iphone",
        "mobile", "www", "client", "official", "inc", "llc", "ltd")

    /** "https://www.GitHub.com/login" or "www.github.com" -> "github.com". */
    fun host(s: String): String {
        var h = s.trim().lowercase()
        h.indexOf("://").takeIf { it >= 0 }?.let { h = h.substring(it + 3) }
        h = h.takeWhile { it != '/' && it != ':' && it != '?' && it != '#' }
        return h.removePrefix("www.")
    }

    /** "GitHub, Inc." -> "githubinc": letters and digits only, for comparing names. */
    fun squash(s: String): String = s.lowercase().filter { it.isLetterOrDigit() }

    /** The name part of a domain: "github" for "github.com" and "accounts.github.com".
     *  shortcut: takes the label before the last dot, so "bbc.co.uk" gives "co"; fine for name matching only. */
    fun siteName(domain: String): String {
        val parts = host(domain).split('.').filter { it.isNotEmpty() }
        return if (parts.size >= 2) parts[parts.size - 2] else parts.firstOrNull() ?: ""
    }

    /** Names an app id may contain to match this account: its websites' names, plus its service name. */
    fun names(a: AutofillAccount): Set<String> =
        (a.domains.map(::siteName) + squash(a.issuer)).filter { it.isNotEmpty() }.toSet()

    /** A website: the account's own or one under it ("accounts.github.com" fits "github.com"). Accounts with
     *  no websites fall back to the service name ("GitHub" fits "github.com"). */
    fun matchesSite(a: AutofillAccount, site: String): Boolean {
        val h = host(site)
        if (h.isEmpty()) return false
        val domains = a.domains.map(::host).filter { it.isNotEmpty() }
        if (domains.isNotEmpty()) return domains.any { h == it || h.endsWith(".$it") }
        return squash(a.issuer).isNotEmpty() && squash(a.issuer) == siteName(h)
    }

    /** An app, by its package ("com.github.android", "com.valvesoftware.android.steam.community"): one word
     *  of the package is one of the account's names. */
    fun matchesApp(a: AutofillAccount, packageName: String): Boolean {
        val words = packageName.lowercase().split('.').toSet() - filler
        return words.any { it in names(a) }
    }

    /** Accounts that fit, websites first. A browser passes the page's website, never its own package. */
    fun ranked(accounts: List<AutofillAccount>, sites: List<String>, apps: List<String> = emptyList()): List<AutofillAccount> {
        val out = LinkedHashSet<AutofillAccount>()
        for (s in sites) accounts.filterTo(out) { matchesSite(it, s) }
        for (p in apps) accounts.filterTo(out) { matchesApp(it, p) }
        return out.toList()
    }

    fun parse(json: String): List<AutofillAccount> = try {
        val arr = JSONArray(json)
        List(arr.length()) { i ->
            val o = arr.getJSONObject(i)
            val domains = o.optJSONArray("domains")
            AutofillAccount(
                o.getString("id"), o.getString("issuer"), o.getString("label"), o.getString("secret"),
                o.getString("algorithm"), o.getInt("digits"), o.getInt("period"),
                o.optString("type", "totp"),
                List(domains?.length() ?: 0) { domains!!.getString(it) },
                o.optBoolean("requireAuth", false),
            )
        }
    } catch (e: Exception) {
        emptyList()
    }
}

/**
 * The accounts copy the autofill service reads, encrypted like the widget's (FavoriteStore). Only exists while
 * "Fill codes with AutoFill" is on; the app erases it when that is turned off. Ask-first accounts are in it
 * too, marked, and the service asks for the screen lock before filling them.
 */
object AutofillStore {
    private const val PREFS = "tanooki_autofill"

    /** Replaces the stored list. An empty list (or bad JSON) erases it. */
    fun save(context: Context, json: String) =
        FavoriteStore.seal(context, PREFS, json.takeIf { AutofillMatch.parse(it).isNotEmpty() })

    fun load(context: Context): List<AutofillAccount> =
        FavoriteStore.unseal(context, PREFS)?.let(AutofillMatch::parse) ?: emptyList()
}
