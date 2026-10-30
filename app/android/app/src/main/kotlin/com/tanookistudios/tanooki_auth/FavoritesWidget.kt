package com.tanookistudios.tanooki_auth

import android.app.AlarmManager
import android.app.KeyguardManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import com.tanookistudios.shared.FavoriteStore

/**
 * Home screen widget: favorites' codes, computed on the phone from the encrypted copy the app keeps
 * while "Show codes on widgets and watch" is on. Shows "Unlock to see codes" while the phone is locked.
 */
class FavoritesWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) = render(context, manager, ids)

    override fun onDisabled(context: Context) {
        alarms(context).cancel(refreshIntent(context))
    }

    companion object {
        private const val MAX_ROWS = 6

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            render(context, manager, manager.getAppWidgetIds(ComponentName(context, FavoritesWidget::class.java)))
        }

        private fun alarms(context: Context) = context.getSystemService(AlarmManager::class.java)

        private fun refreshIntent(context: Context): PendingIntent = PendingIntent.getBroadcast(
            context, 0,
            Intent(context, FavoritesWidget::class.java).setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                .putExtra(
                    AppWidgetManager.EXTRA_APPWIDGET_IDS,
                    AppWidgetManager.getInstance(context).getAppWidgetIds(ComponentName(context, FavoritesWidget::class.java)),
                ),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            if (ids.isEmpty()) return
            val locked = context.getSystemService(KeyguardManager::class.java).isKeyguardLocked
            val favorites = if (locked) emptyList() else FavoriteStore.load(context)
            val nowMs = System.currentTimeMillis()
            val now = nowMs / 1000
            val views = RemoteViews(context.packageName, R.layout.widget_favorites)
            views.removeAllViews(R.id.rows)
            val message = when {
                locked -> context.getString(R.string.widget_locked)
                favorites.isEmpty() -> context.getString(R.string.widget_empty)
                else -> null
            }
            views.setViewVisibility(R.id.message, if (message == null) View.GONE else View.VISIBLE)
            views.setTextViewText(R.id.message, message ?: "")
            for (f in favorites.take(MAX_ROWS)) {
                val row = RemoteViews(context.packageName, R.layout.widget_row)
                row.setTextViewText(R.id.title, f.badgedTitle)
                f.color?.let { row.setTextColor(R.id.title, it) }
                row.setTextViewText(R.id.code, com.tanookistudios.shared.Totp.grouped(f.code(now)))
                // Counts down to this code's expiry; going negative shows it is stale until the next refresh.
                val leftMs = f.period * 1000L - nowMs % (f.period * 1000L)
                row.setChronometer(R.id.left, SystemClock.elapsedRealtime() + leftMs, null, true)
                row.setChronometerCountDown(R.id.left, true)
                views.addView(R.id.rows, row)
            }
            // Tap anywhere: refresh now.
            views.setOnClickPendingIntent(R.id.root, refreshIntent(context))
            manager.updateAppWidget(ids, views)

            // Next refresh at the earliest code change. Non-wakeup, so it waits while the screen is off.
            // shortcut: inexact alarm (exact alarms need a permission Android 14 denies by default), so a
            // code can sit stale for a few seconds; the countdown shows it. Upgrade if users complain.
            val nextMs = favorites.minOfOrNull { it.period * 1000L - nowMs % (it.period * 1000L) } ?: return
            alarms(context).set(AlarmManager.ELAPSED_REALTIME, SystemClock.elapsedRealtime() + nextMs + 200, refreshIntent(context))
        }
    }
}
