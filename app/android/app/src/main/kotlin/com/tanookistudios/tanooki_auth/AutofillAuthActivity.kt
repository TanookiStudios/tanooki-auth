package com.tanookistudios.tanooki_auth

import android.app.Activity
import android.app.KeyguardManager
import android.content.Intent
import android.hardware.biometrics.BiometricManager
import android.hardware.biometrics.BiometricPrompt
import android.os.Build
import android.os.Bundle
import android.os.CancellationSignal
import android.service.autofill.Dataset
import android.view.autofill.AutofillId
import android.view.autofill.AutofillManager
import android.view.autofill.AutofillValue
import androidx.annotation.RequiresApi
import com.tanookistudios.shared.AutofillStore

/**
 * Opens (invisibly) when the person picks a Tanooki Auth code in the autofill pop-up. Not exported: only the
 * autofill service's own pending intents can start it. Works the code out now and hands it back to Android;
 * for an ask-first account it asks for fingerprint, face or the screen lock first, and fills nothing if
 * that is cancelled or the phone has no screen lock.
 */
@RequiresApi(Build.VERSION_CODES.O)
class AutofillAuthActivity : Activity() {
    companion object {
        const val EXTRA_ACCOUNT = "account"
        const val EXTRA_FIELD = "field"
        private const val CONFIRM = 1
    }

    private val account by lazy { AutofillStore.load(this).firstOrNull { it.id == intent.getStringExtra(EXTRA_ACCOUNT) } }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) return // the prompt is already up
        val a = account ?: return done(false)
        if (!a.requireAuth) return done(true)
        val title = getString(R.string.autofill_auth_title)
        if (Build.VERSION.SDK_INT >= 29) {
            val prompt = BiometricPrompt.Builder(this).setTitle(title).setSubtitle(a.suggestionLabel).apply {
                if (Build.VERSION.SDK_INT >= 30) {
                    setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_WEAK or BiometricManager.Authenticators.DEVICE_CREDENTIAL)
                } else {
                    @Suppress("DEPRECATION") setDeviceCredentialAllowed(true)
                }
            }.build()
            prompt.authenticate(CancellationSignal(), mainExecutor, object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) = done(true)
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) = done(false)
            })
        } else {
            @Suppress("DEPRECATION")
            val confirm = getSystemService(KeyguardManager::class.java).createConfirmDeviceCredentialIntent(title, a.suggestionLabel)
                ?: return done(false) // no screen lock: an ask-first account can't be checked, so it isn't filled
            @Suppress("DEPRECATION") startActivityForResult(confirm, CONFIRM)
        }
    }

    @Deprecated("Only for the screen-lock prompt on Android 8 and 9")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == CONFIRM) done(resultCode == RESULT_OK)
    }

    private fun done(fill: Boolean) {
        @Suppress("DEPRECATION")
        val field = intent.getParcelableExtra<AutofillId>(EXTRA_FIELD)
        val code = account?.code(System.currentTimeMillis() / 1000)
        if (fill && field != null && code != null) {
            @Suppress("DEPRECATION") // Field-based builders are API 33+; this still works there.
            val dataset = Dataset.Builder().setValue(field, AutofillValue.forText(code)).build()
            setResult(RESULT_OK, Intent().putExtra(AutofillManager.EXTRA_AUTHENTICATION_RESULT, dataset))
        } else {
            setResult(RESULT_CANCELED)
        }
        finish()
    }
}
