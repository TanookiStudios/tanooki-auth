package com.tanookistudios.tanooki_auth

import android.app.PendingIntent
import android.app.assist.AssistStructure
import android.content.Intent
import android.os.Build
import android.os.CancellationSignal
import android.service.autofill.AutofillService
import android.service.autofill.Dataset
import android.service.autofill.FillCallback
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.service.autofill.SaveCallback
import android.service.autofill.SaveRequest
import android.view.View
import android.view.autofill.AutofillId
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import com.tanookistudios.shared.AutofillMatch
import com.tanookistudios.shared.AutofillStore

/**
 * Android autofill: when an app or website shows a 2FA code box, offers the code of each account that fits
 * (the website's domain in a browser, else the app's package name). Picking one opens AutofillAuthActivity,
 * which works the code out at that moment (so it is never stale) and asks for the screen lock first for
 * ask-first accounts. Only active while the person has picked Tanooki Auth as their autofill service.
 */
@RequiresApi(Build.VERSION_CODES.O)
class TanookiAutofillService : AutofillService() {
    override fun onFillRequest(request: FillRequest, cancellationSignal: CancellationSignal, callback: FillCallback) {
        val structure = request.fillContexts.last().structure
        val app = structure.activityComponent.packageName
        if (app == packageName) return callback.onSuccess(null)
        val found = Fields()
        for (i in 0 until structure.windowNodeCount) found.walk(structure.getWindowNodeAt(i).rootViewNode)
        val field = found.focusedCode ?: found.firstCode ?: return callback.onSuccess(null)
        val accounts = AutofillStore.load(this)
        // In a browser the page's website decides; the browser's own package says nothing about the page.
        val matches = found.webDomain?.let { AutofillMatch.ranked(accounts, listOf(it)) }
            ?: AutofillMatch.ranked(accounts, emptyList(), listOf(app))
        if (matches.isEmpty()) return callback.onSuccess(null)
        val response = FillResponse.Builder()
        for ((i, a) in matches.take(5).withIndex()) {
            val row = RemoteViews(packageName, android.R.layout.simple_list_item_1).apply {
                setTextViewText(android.R.id.text1, "Tanooki Auth: ${a.suggestionLabel}")
            }
            val pick = Intent(this, AutofillAuthActivity::class.java)
                .putExtra(AutofillAuthActivity.EXTRA_ACCOUNT, a.id)
                .putExtra(AutofillAuthActivity.EXTRA_FIELD, field)
            // Mutable: Android adds the screen's details to it before starting the activity.
            val flags = PendingIntent.FLAG_CANCEL_CURRENT or (if (Build.VERSION.SDK_INT >= 31) PendingIntent.FLAG_MUTABLE else 0)
            val sender = PendingIntent.getActivity(this, i, pick, flags).intentSender
            @Suppress("DEPRECATION") // Field-based builders are API 33+; these still work there.
            response.addDataset(Dataset.Builder(row).setValue(field, null, row).setAuthentication(sender).build())
        }
        callback.onSuccess(response.build())
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) = callback.onSuccess() // never saves anything

    /** The code box on screen (focused one first) and the page's website, if it is a browser. */
    private class Fields {
        var focusedCode: AutofillId? = null
        var firstCode: AutofillId? = null
        var webDomain: String? = null

        fun walk(node: AssistStructure.ViewNode) {
            node.webDomain?.takeIf { it.isNotBlank() }?.let { webDomain = webDomain ?: it }
            val id = node.autofillId
            if (id != null && node.autofillType == View.AUTOFILL_TYPE_TEXT && looksLikeCode(node)) {
                if (node.isFocused) focusedCode = id
                if (firstCode == null) firstCode = id
            }
            for (i in 0 until node.childCount) walk(node.getChildAt(i))
        }
    }

    companion object {
        private val codeWords = Regex("otp|one.?time|2fa|two.?factor|mfa|totp|verif|security.?code|auth.?code|passcode|token|\\bcode\\b")

        /** A box asking for a one-time code: its autofill hints, HTML autocomplete, or its name/hint text. */
        fun looksLikeCode(node: AssistStructure.ViewNode): Boolean {
            val hints = node.autofillHints.orEmpty().map { it.lowercase() }
            // "smsOTPCode" / "2faAppOTPCode" (androidx HintConstants) and HTML autocomplete="one-time-code".
            if (hints.any { "otp" in it || it == "one-time-code" }) return true
            val html = node.htmlInfo?.attributes.orEmpty()
            if (html.any { it.first == "autocomplete" && it.second == "one-time-code" }) return true
            val text = listOfNotNull(node.idEntry, node.hint, node.contentDescription?.toString(),
                html.firstOrNull { it.first == "name" || it.first == "id" }?.second)
                .joinToString(" ").lowercase().replace('_', ' ')
            return codeWords.containsMatchIn(text)
        }
    }
}
