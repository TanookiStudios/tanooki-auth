package com.tanookistudios.auth.wear

import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import com.google.android.gms.wearable.Wearable
import com.tanookistudios.shared.FavoriteStore
import com.tanookistudios.shared.Totp

/** Favorites' codes, worked out on the watch every second. */
class MainActivity : Activity() {
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var list: LinearLayout
    private val tick = object : Runnable {
        override fun run() {
            render()
            handler.postDelayed(this, 1000)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        list = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(24, 48, 24, 48)
        }
        setContentView(ScrollView(this).apply { addView(list) })
    }

    override fun onResume() {
        super.onResume()
        // Catch up on anything sent while the app wasn't listening (or the phone turned sharing off).
        Wearable.getDataClient(this).getDataItems(Uri.parse("wear://*/favorites")).addOnSuccessListener { items ->
            val json = items.firstOrNull()?.data?.let { String(it) } ?: "[]"
            items.release()
            FavoriteStore.save(this, json)
            render()
        }
        handler.post(tick)
    }

    override fun onPause() {
        handler.removeCallbacks(tick)
        super.onPause()
    }

    private fun text(s: String, size: Float, bold: Boolean = false) = TextView(this).apply {
        text = s
        textSize = size
        gravity = Gravity.CENTER
        if (bold) setTypeface(typeface, android.graphics.Typeface.BOLD)
    }

    private fun render() {
        list.removeAllViews()
        val favorites = FavoriteStore.load(this)
        if (favorites.isEmpty()) {
            list.addView(text("No favorites yet.\n\nOn your phone, open Tanooki Auth, star an account, and turn on Settings > Show codes on widgets and watch.", 13f))
            return
        }
        val now = System.currentTimeMillis() / 1000
        for (f in favorites) {
            list.addView(text(f.title, 12f))
            list.addView(text(Totp.grouped(f.code(now)), 24f, bold = true))
            list.addView(text("${f.period - now % f.period}s", 10f))
        }
    }
}
