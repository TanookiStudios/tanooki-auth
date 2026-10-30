package com.tanookistudios.auth.wear

import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.WearableListenerService
import com.tanookistudios.shared.FavoriteStore

/** Receives the favorites list from the phone app and keeps it encrypted on the watch. */
class FavoritesListener : WearableListenerService() {
    override fun onDataChanged(events: DataEventBuffer) {
        for (e in events) {
            if (e.dataItem.uri.path != "/favorites") continue
            val json = if (e.type == DataEvent.TYPE_DELETED) "[]" else String(e.dataItem.data ?: ByteArray(0))
            FavoriteStore.save(this, json)
        }
    }
}
