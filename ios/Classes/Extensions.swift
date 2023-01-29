//
//  Extensions.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/22/22.
//

import Foundation

extension RGBAColor {
    var uiColor: UIColor {
        UIColor(
            red: red ?? 0,
            green: green ?? 0,
            blue: blue ?? 0,
            alpha: 1.0
        )
    }
}

struct Weak<T: AnyObject> {
    weak var value: T?
}

extension NSNumber {
    var bool: Bool {
        self == 1
    }

    var int: Int {
        Int(truncating: self)
    }

    var int64: Int64 {
        Int64(truncating: self)
    }
}

extension Int32 {
    var int: Int {
        Int(self)
    }

    var int32: Int32 {
        Int32(self)
    }
}

extension Int64 {
    var int: Int {
        Int(self)
    }

    var int32: Int32 {
        Int32(self)
    }
}

extension Int {
    var int32: Int32 {
        Int32(self)
    }
}

#if DEBUG
    extension UIView {
        func printSubviews(level: Int = 0) {
            print(String(repeating: "\t", count: level), self)
            for subview in subviews {
                subview.printSubviews(level: level + 1)
            }
        }
    }
#endif
