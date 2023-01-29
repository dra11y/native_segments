package com.dra11y.flutter.native_segments

import java.lang.ref.WeakReference

interface NativeSegmentsApiManagement {
    var controllers: MutableMap<String, WeakReference<NativeSegmentsViewController>>
    fun register(controller: NativeSegmentsViewController)
    fun deregisterIfNeeded(controller: NativeSegmentsViewController)
    fun controller(id: String): NativeSegmentsViewController? = controllers[id]?.get()
}

class NativeSegmentsHostApiAndroid : NativeSegmentsHostApi, NativeSegmentsApiManagement {
    override fun setSegments(id: String, segments: List<NativeSegment>, selectedIndex: Long?): Boolean {
        return controller(id)?.setSegments(segments, selectedIndex = selectedIndex?.toInt()) ?: false
    }

    override fun setStyle(id: String, style: NativeSegmentsApiStyle): Boolean {
        return controller(id)?.setStyle(style) ?: false
    }

    override fun setSelected(id: String, index: Long?): Boolean {
        return false
    }

    override var controllers: MutableMap<String, WeakReference<NativeSegmentsViewController>> = mutableMapOf()

    override fun register(controller: NativeSegmentsViewController) {
        controllers[controller.id] = WeakReference(controller)
    }

    override fun deregisterIfNeeded(controller: NativeSegmentsViewController) {
        controllers[controller.id]?.get()?.let { registeredController ->
            if (registeredController.viewId == controller.viewId) {
                controllers.remove(controller.id)
            }
        }
    }
}
