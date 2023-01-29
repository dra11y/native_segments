package com.dra11y.flutter.native_segments

import android.content.Context
import io.flutter.plugin.common.JSONMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.json.JSONObject

class NativeSegmentsViewFactory(
    private val hostApi: NativeSegmentsHostApiAndroid,
    private val flutterApi: NativeSegmentsFlutterApi,
) : PlatformViewFactory(JSONMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val id = (args as? JSONObject)?.optString("id") ?:
            throw Error("Instance ID must be passed from Flutter via JSONMessageCodec as { 'id': String }")
        return NativeSegmentsViewController(
            id = id,
            context = context,
            viewId = viewId,
            hostApi = hostApi,
            flutterApi = flutterApi,
        )
    }
}
