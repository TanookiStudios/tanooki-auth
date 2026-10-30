package com.tanookistudios.tanooki_auth

import android.content.Intent
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

    private fun actionOf(intent: Intent?): String? = if (intent?.dataString == SCAN_URI) "scan" else null

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
