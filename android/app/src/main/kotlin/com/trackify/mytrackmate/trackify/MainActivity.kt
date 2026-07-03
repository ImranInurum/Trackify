package com.trackify.mytrackmate.trackify

import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.trackify.mytrackmate.trackify/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openNotificationChannelSettings") {
                val channelId = call.argument<String>("channelId")
                if (channelId != null) {
                    openNotificationChannelSettings(channelId)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGUMENT", "Channel ID is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openNotificationChannelSettings(channelId: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
            intent.putExtra(Settings.EXTRA_CHANNEL_ID, channelId)
            startActivity(intent)
        } else {
            // Fallback for devices below Android 8 (API 26)
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            val uri = android.net.Uri.fromParts("package", packageName, null)
            intent.data = uri
            startActivity(intent)
        }
    }
}