//
//  SwizzleUISegment.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/27/22.
//

import ObjectiveC
import UIKit

@available(iOS 13.0, *)
private class SwizzledUISegment: UIImageView {
    /// Prevent the selected button from turning gray while pressed.
    @objc dynamic var swizzled_tintAdjustmentMode: UIView.TintAdjustmentMode {
        return swizzled_tintAdjustmentMode
//        return .normal
    }

    /// The internal `UISegment` method `_effectiveSelectedSegmentTintColor` sets the color of the
    /// large content viewer's selected segment background. Unfortunately, it always returns
    /// white in light mode and gray in dark mode. We make it dynamic by swizzling the `UISegment` class.
    /// The `UISegment` elements in the large content viewer are **copies** of the subviews
    /// of the actual control, that drop all but a few properties. Fortunately, `tintColor`
    /// is copied over, so we use `tintColor` to propagate the selected background color.
    /// This property affects **only** the Large Content Viewer, not the segments themselves.
    @objc dynamic var swizzled_effectiveSelectedSegmentTintColor: UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        guard
            tintColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        else { return tintColor }

        /// Apple modifies the tint color in both dark and light modes for some reason.
        /// These compensation values are experimentally determined.
        /// Further testing might be needed on a variety of colors.
        /// `alpha` should always be 1.0 for accessibility.
        return tintColor
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let brightness = isDarkMode ? b / 1.2 : b * 1.33
        let saturation = isDarkMode ? s * 1.5 : s
        return UIColor(
            hue: h,
            saturation: max(min(saturation, 1.0), 0),
            brightness: max(min(brightness, 1.0), 0),
            alpha: 1.0
        )
    }
}

@available(iOS 13.0, *)
class UISegmentSwizzler {
    private static var isSwizzled = false // Make idempotent

    private let klassName = "UISegment"
    private let swizzledClass = SwizzledUISegment.self

    init() {
        if Self.isSwizzled { return }
        Self.isSwizzled = true

        guard
            let klass = NSClassFromString(klassName)
        else {
            assertionFailure("Could not get \(klassName) class!")
            return
        }

        swizzle(
            klass: klass,
            originalSelector: NSSelectorFromString("_effectiveSelectedSegmentTintColor"),
            swizzledSelector: #selector(getter: SwizzledUISegment.swizzled_effectiveSelectedSegmentTintColor)
        )

        swizzle(
            klass: klass,
            originalSelector: #selector(getter: UIImageView.tintAdjustmentMode),
            swizzledSelector: #selector(getter: SwizzledUISegment.swizzled_tintAdjustmentMode)
        )
    }

    private func swizzle(klass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard
            let originalMethod = class_getInstanceMethod(klass, originalSelector)
        else {
            assertionFailure("Could not get original method!")
            return
        }

        guard
            let swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector)
        else {
            assertionFailure("Could not get swizzled method!")
            return
        }

        let didAdd = class_addMethod(klass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))

        if didAdd {
            class_replaceMethod(klass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
