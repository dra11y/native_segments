package com.dra11y.flutter.native_segments

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

class NativeSegmentsPlugin : FlutterPlugin {
    companion object {
        const val viewTypeId = "com.dra11y.flutter.native_segments.android"
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        val hostApi = NativeSegmentsHostApiAndroid()
        val flutterApi = NativeSegmentsFlutterApi(binaryMessenger = flutterPluginBinding.binaryMessenger)

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(
                viewTypeId,
                NativeSegmentsViewFactory(
                    hostApi = hostApi,
                    flutterApi = flutterApi,
                ),
            )

        NativeSegmentsHostApi.setUp(flutterPluginBinding.binaryMessenger, api = hostApi)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {
        NativeSegmentsHostApi.setUp(binding.binaryMessenger, api = null)
    }
}
