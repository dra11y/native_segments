//
//  MySegmentedControl.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/26/22.
//

import UIKit

class MySegmentedControl: UISegmentedControl {
    private static func defaultUnscaledHeight() -> CGFloat {
        UIFontMetrics.default.scaledFont(
            for: .boldSystemFont(ofSize: UIFont.systemFontSize)).lineHeight
    }

    private func defaultSelectedColor() -> UIColor {
        if #available(iOS 12.0, *) {
            return isDark ? .gray : .white
        } else {
            return UIColor.systemBlue
        }
    }

    private func defaultSelectedTextColor() -> UIColor {
        return UIColor.white
    }

    // Allow consumer override of dark theme, fallback to automatic.
    @available(iOS 12.0, *)
    private var isDark: Bool {
        style.isDarkTheme ?? (traitCollection.userInterfaceStyle == .dark)
    }

    private func updateBackgroundColor() {
        /// Very bizarre way that Apple sets the background color for this control.
        /// After layout, they duplicate the `UISegment`s (`UIImageView`s) and
        /// insert them "behind" the segment labels in the view stack.
        /// If we just set `self.backgroundColor`, that gets tinted by
        /// Apple's default background color, which is no good.
        /// So, we get all the background color images from the subviews
        /// that are *exactly* `UIImageView.self` (not a subclass),
        /// and skipping the last one (because it is the selected segment's
        /// highlight!!
        guard
            #available(iOS 13.0, *),
            let backgroundImageViews = (
                subviews.filter { subview in
                    type(of: subview) == UIImageView.self
                }
                    as? [UIImageView]
            )?.dropLast()
        else { return }

        if style.isDarkTheme == nil { return }

        let bgColor = computeBackgroundColor()
        for imageView in backgroundImageViews {
            imageView.tintAdjustmentMode = .normal
            imageView.backgroundColor = bgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBackgroundColor()
    }

    private func computeBackgroundColor() -> UIColor {
        if style.isDarkTheme == nil {
            if #available(iOS 13.0, *) {
                return .quaternarySystemFill
            }
        }
        if #available(iOS 12.0, *) {
            return isDark ? (
                style.backgroundColorDark?.uiColor ??
                    style.backgroundColor?.uiColor ??
                UIColor(white: 0.2, alpha: 1)) : (
                    style.backgroundColor?.uiColor ?? UIColor(white: 0.9, alpha: 1))
        }
        /// Pre-iOS 12 segmented background.
        return .white
    }

    private func defaultUnselectedTextColor() -> UIColor {
        if #available(iOS 12.0, *) {
            return isDark ? .white : .black
        } else {
            return UIColor.black
        }
    }

    private typealias TextAttributesDict = [NSAttributedString.Key: Any]

    public private(set) var height: CGFloat = MySegmentedControl.defaultUnscaledHeight() {
        didSet {
            guard height != oldValue else { return }
            heightChanged?(height)
        }
    }

    // Force update when light/dark mode is toggled or preferred font size changed.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setStyle(style: style)
    }

    @available(iOS 13.0, *)
    override var selectedSegmentTintColor: UIColor? {
        get { super.selectedSegmentTintColor }
        set {
            super.selectedSegmentTintColor = newValue
            for subview in subviews {
                if let imageView = subview as? UIImageView {
                    // Set the selected item background color for the Large Content Viewer.
                    // Only works if `UISegment._effectiveSelectedSegmentTintColor` is swizzled
                    // to return this property. Does not affect the segments themselves.
                    imageView.tintColor = selectedSegmentTintColor ?? defaultSelectedColor()
                }
            }
        }
    }

    public var heightChanged: ((CGFloat) -> Void)?

    func setStyle(style: NativeSegmentsApiStyle) {
        self.style = style

        let enableDynamicType = style.enableDynamicType ?? true

        let normalFont: UIFont
        let boldFont: UIFont

        normalFont = enableDynamicType ? UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: UIFont.systemFontSize)) : UIFont.systemFont(ofSize: UIFont.systemFontSize)

        boldFont = enableDynamicType ? UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: UIFont.systemFontSize)) : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)

        // Experimentally determined height from Apple default behavior.
        height = boldFont.lineHeight + 16.0

        let selectedTextAttributes: TextAttributesDict = [
            .foregroundColor: style.selectedTextColor?.uiColor ?? defaultSelectedTextColor(),
            .font: boldFont,
        ].compactMapValues { $0 }

        let normalTextAttributes: TextAttributesDict = [
            .foregroundColor: style.textColor?.uiColor ?? defaultUnselectedTextColor(),
            .font: normalFont,
        ].compactMapValues { $0 }

        if let variableWidths = style.variableWidths {
            apportionsSegmentWidthsByContent = variableWidths
        }

        clipsToBounds = true

        let selectedSegmentColor = style.selectedSegmentColor?.uiColor
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = selectedSegmentColor
        } else {
            tintColor = selectedSegmentColor
        }

        setTitleTextAttributes(selectedTextAttributes, for: .selected)
        setTitleTextAttributes(normalTextAttributes, for: .normal)

        updateBackgroundColor()
    }

    private var style = NativeSegmentsApiStyle()
}
