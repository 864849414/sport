package com.sport583.sport

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

internal class MyApplication : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry)
    }
}