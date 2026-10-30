package com.tanookistudios.tanooki_auth

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.provider.DocumentsContract
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.FileNotFoundException
import java.io.IOException
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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "tanooki/folder").setMethodCallHandler(::onFolderCall)
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

    // ---- tanooki/folder: the automatic-backup folder, through the Storage Access Framework ----
    // pick -> {ref (tree URI), name} or null; list/write/delete {ref, name, bytes}. Error codes are the Dart
    // AutoBackupFailure names: folderGone, permissionLost, diskFull, other.

    private val pickFolderRequest = 4141
    private var pickFolderResult: MethodChannel.Result? = null

    private class FolderError(val code: String, message: String?) : Exception(message)

    private fun onFolderCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "pick") {
            pickFolderResult?.success(null)
            pickFolderResult = result
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
            )
            @Suppress("DEPRECATION")
            startActivityForResult(intent, pickFolderRequest)
            return
        }
        val ref = call.argument<String>("ref") ?: return result.error("folderGone", "no folder", null)
        val name = call.argument<String>("name")
        val bytes = call.argument<ByteArray>("bytes")
        Thread {
            val reply: Result<Any?> = try {
                val tree = Uri.parse(ref)
                checkFolder(tree)
                Result.success(
                    when (call.method) {
                        "list" -> children(tree).keys.toList()
                        "write" -> writeChild(tree, name!!, bytes!!).let { null }
                        "delete" -> children(tree)[name]?.let { DocumentsContract.deleteDocument(contentResolver, it) }.let { null }
                        else -> throw FolderError("notImplemented", call.method)
                    }
                )
            } catch (e: Exception) {
                Result.failure(e)
            }
            runOnUiThread {
                reply.fold({ result.success(it) }) { e ->
                    when {
                        e is FolderError && e.code == "notImplemented" -> result.notImplemented()
                        e is FolderError -> result.error(e.code, e.message, null)
                        e is SecurityException -> result.error("permissionLost", e.message, null)
                        e is FileNotFoundException -> result.error("folderGone", e.message, null)
                        e is IOException && (e.message ?: "").let { it.contains("ENOSPC") || it.contains("No space") } ->
                            result.error("diskFull", e.message, null)
                        else -> result.error("other", e.message ?: e.javaClass.simpleName, null)
                    }
                }
            }
        }.start()
    }

    /** Still allowed to write there (the user can revoke it), and the folder still exists. */
    private fun checkFolder(tree: Uri) {
        val granted = contentResolver.persistedUriPermissions.any { it.uri == tree && it.isWritePermission }
        if (!granted) throw FolderError("permissionLost", "no write permission for $tree")
        val doc = DocumentsContract.buildDocumentUriUsingTree(tree, DocumentsContract.getTreeDocumentId(tree))
        val exists = try {
            contentResolver.query(doc, arrayOf(DocumentsContract.Document.COLUMN_DOCUMENT_ID), null, null, null)?.use { it.moveToFirst() } == true
        } catch (e: Exception) {
            false
        }
        if (!exists) throw FolderError("folderGone", "$tree")
    }

    /** File name -> document URI for everything directly inside the folder. */
    private fun children(tree: Uri): Map<String, Uri> {
        val parent = DocumentsContract.getTreeDocumentId(tree)
        val list = DocumentsContract.buildChildDocumentsUriUsingTree(tree, parent)
        val out = mutableMapOf<String, Uri>()
        contentResolver.query(
            list,
            arrayOf(DocumentsContract.Document.COLUMN_DOCUMENT_ID, DocumentsContract.Document.COLUMN_DISPLAY_NAME, DocumentsContract.Document.COLUMN_MIME_TYPE),
            null, null, null
        )?.use { c ->
            while (c.moveToNext()) {
                if (c.getString(2) == DocumentsContract.Document.MIME_TYPE_DIR) continue
                out[c.getString(1)] = DocumentsContract.buildDocumentUriUsingTree(tree, c.getString(0))
            }
        }
        return out
    }

    /** Replaces the file if it's there (truncating), else creates it, so there are never "name (1)" copies. */
    private fun writeChild(tree: Uri, name: String, bytes: ByteArray) {
        val doc = children(tree)[name] ?: DocumentsContract.createDocument(
            contentResolver,
            DocumentsContract.buildDocumentUriUsingTree(tree, DocumentsContract.getTreeDocumentId(tree)),
            "application/octet-stream",
            name
        ) ?: throw FolderError("other", "couldn't create $name")
        (contentResolver.openOutputStream(doc, "wt") ?: throw FolderError("other", "couldn't open $name")).use { it.write(bytes) }
    }

    @Deprecated("startActivityForResult is enough for one folder picker")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != pickFolderRequest) return
        val result = pickFolderResult ?: return
        pickFolderResult = null
        val tree = data?.data
        if (resultCode != RESULT_OK || tree == null) return result.success(null)
        try {
            contentResolver.takePersistableUriPermission(tree, Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            val doc = DocumentsContract.buildDocumentUriUsingTree(tree, DocumentsContract.getTreeDocumentId(tree))
            val name = contentResolver.query(doc, arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME), null, null, null)
                ?.use { if (it.moveToFirst()) it.getString(0) else null } ?: "Backup folder"
            result.success(mapOf("ref" to tree.toString(), "name" to name))
        } catch (e: Exception) {
            result.error("permissionLost", e.message, null)
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
