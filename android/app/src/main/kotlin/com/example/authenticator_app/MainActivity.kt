package com.example.authenticator_app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowManager

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}