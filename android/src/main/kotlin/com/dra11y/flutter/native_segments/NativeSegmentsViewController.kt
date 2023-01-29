package com.dra11y.flutter.native_segments

import android.content.Context
import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.google.android.material.tabs.TabLayout
import io.flutter.plugin.platform.PlatformView
import kotlin.math.roundToInt

interface NativeSegmentsViewControllerApi {
    val viewId: Int
    fun setSegments(segments: List<NativeSegment>, selectedIndex: Int?): Boolean
    fun setStyle(style: NativeSegmentsApiStyle): Boolean
}

class NativeSegmentsViewController(
    val id: String,
    private val context: Context,
    override val viewId: Int,
    private val hostApi: NativeSegmentsHostApiAndroid,
    private val flutterApi: NativeSegmentsFlutterApi,
) : PlatformView, NativeSegmentsViewControllerApi {
    private var tabLayout = MyTabLayout(id = id, context = context, flutterApi = flutterApi)

    private fun setupTabLayout() {
        val layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        tabLayout.layoutParams = layoutParams
        tabLayout.tabGravity = TabLayout.GRAVITY_FILL
        tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            override fun onTabSelected(tab: TabLayout.Tab) {
                flutterApi.valueChanged(
                    id,
                    tab.position.toLong(),
                ) { }
            }

            override fun onTabUnselected(tab: TabLayout.Tab) {
            }

            override fun onTabReselected(tab: TabLayout.Tab) {
            }
        })
        val defaultLineHeight = 14.0
        val wantedHeight = 48.0 - defaultLineHeight + (defaultLineHeight * context.resources.configuration.fontScale)
        flutterApi.wantsHeight(id, wantedHeight) { }
    }

    init {
        hostApi.register(this)
    }

    override fun getView(): View {
        setupTabLayout()
        return tabLayout
    }

    override fun dispose() {
    }

    override fun setSegments(segments: List<NativeSegment>, selectedIndex: Int?): Boolean {
        tabLayout.setSegments(segments)
        selectedIndex?.let { tabLayout.setSelected(it) }
        return true
    }

    override fun setStyle(style: NativeSegmentsApiStyle): Boolean = tabLayout.setStyle(style)
}

fun <T : Comparable<T>> T.clamped(minimum: T, maximum: T): T = minOf(maxOf(this, minimum), maximum)

fun RGBAColor.Companion.colorInt(value: Double?): Int =
    ((value ?: 0.0) * 255.0).roundToInt().clamped(0, 255)

val RGBAColor.color: Int
    get() = Color.argb(
        RGBAColor.colorInt(alpha),
        RGBAColor.colorInt(red),
        RGBAColor.colorInt(green),
        RGBAColor.colorInt(blue)
    )
