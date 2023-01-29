package com.dra11y.flutter.native_segments

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.os.Build
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import com.google.android.material.tabs.TabLayout
import kotlin.math.max
import kotlin.math.roundToInt

@SuppressLint("ViewConstructor")
class MyTabLayout(private val id: String, context: Context, private val flutterApi: NativeSegmentsFlutterApi) : TabLayout(context) {
    private var style: NativeSegmentsApiStyle? = null
    private var isNightMode: Boolean = getIsNightMode()

    private val segments: MutableList<NativeSegment> = mutableListOf()

    fun setSegments(segments: List<NativeSegment>) {
        this.segments.clear()
        this.segments.addAll(segments)
        replaceTabs()
    }

    fun setSelected(index: Int) {
        getTabAt(index)?.select()
    }

    private fun replaceTabs() {
        removeAllTabs()
        segments.map { segment ->
            newTab().setText(segment.title)
        }
            .forEach { tab ->
                addTab(tab)
            }
    }

    companion object {
        // Default Material Colors:
        // https://material.io/design/color/the-color-system.html
        // https://material.io/design/color/dark-theme.html
        private val defaultMaterialSurface = Color.parseColor("#FFFFFF")
        private val defaultMaterialSurfaceVariant = Color.parseColor("#121212")
        private val defaultMaterialOnSurface = Color.parseColor("#99000000")
        private val defaultMaterialOnSurfaceVariant = Color.parseColor("#99FFFFFF")
        private val defaultMaterialOnSurfaceSelected = Color.parseColor("#000000")
        private val defaultMaterialOnSurfaceSelectedVariant = Color.parseColor("#FFFFFF")
        private val defaultMaterialPrimaryText = Color.parseColor("#6200EE")
        private val defaultMaterialPrimaryTextVariant = Color.parseColor("#BA86FC")
    }

    private val materialSurface: Int
        get() = if (isNightMode) defaultMaterialSurfaceVariant else defaultMaterialSurface

    private val materialOnSurface: Int
        get() = if (isNightMode) defaultMaterialOnSurfaceVariant else defaultMaterialOnSurface

    private val materialOnSurfaceSelected: Int
        get() = if (isNightMode) defaultMaterialOnSurfaceSelectedVariant else defaultMaterialOnSurfaceSelected

    private val materialPrimaryText: Int
        get() = if (isNightMode) defaultMaterialPrimaryTextVariant else defaultMaterialPrimaryText

    private fun getIsNightMode(isDarkTheme: Boolean? = null): Boolean =
        isDarkTheme ?: (
            Configuration.UI_MODE_NIGHT_YES == (
                    context.resources.configuration.uiMode
                        .and(Configuration.UI_MODE_NIGHT_MASK)
                )
            )

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onConfigurationChanged(newConfig: Configuration?) {
        super.onConfigurationChanged(newConfig)
        flutterApi.refresh(id) {  }
    }

    fun setStyle(style: NativeSegmentsApiStyle?): Boolean {
//        val scaler = resources.displayMetrics.density * ((resources.configuration.fontScale - 1) * 10)
        val defaultIndicatorHeight = 5
        // `fontScale` default = 1.0, max on Pixel 6 = 1.3
        val scaler = (resources.configuration.fontScale - 1) * 10
        val indicatorHeight = max((scaler * defaultIndicatorHeight).roundToInt(), defaultIndicatorHeight)

        // FIXME: This is deprecated. No idea why, but apparently we need to create a custom indicator.
        setSelectedTabIndicatorHeight(indicatorHeight)

        val newStyle = style ?: this.style
        this.style = newStyle
        isNightMode = getIsNightMode(newStyle?.isDarkTheme)

        setBackgroundColor(newStyle?.backgroundColor?.color ?: materialSurface)

        setTabTextColors(
            newStyle?.textColor?.color ?: materialOnSurface,
            newStyle?.selectedTextColor?.color
                ?: newStyle?.selectedSegmentColor?.color
                ?: materialOnSurfaceSelected,
        )

        setSelectedTabIndicatorColor(newStyle?.selectedSegmentColor?.color ?: materialPrimaryText)


//        replaceTabs()

//        for (i in 0 until tabCount) {
////            getTabAt(i)?.view?.invalidateRecursive()
//            getTabAt(i)?.view?.context?.let { qwef ->
//                context
//            }
//        }

        return true
    }
}

fun Int.toHex(): String = String.format("#%06X", 0xFFFFFF and this)

fun ViewGroup.invalidateRecursive() {
    for (i in 0 until childCount) {
        getChildAt(i)?.let { child ->
            if (child is ViewGroup) child.invalidateRecursive()
            else child.invalidate()
        }
    }
}
