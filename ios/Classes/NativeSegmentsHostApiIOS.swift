//
//  NativeSegmentsApiIOS.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/22/22.
//

import Flutter

// NativeSegmentsApi Host API implementation class.
// Currently, since Pigeon does not yet support multiple API/channel instances,
// we pass the id in each API call from Flutter, and delegate the method
// to the appropriate registered view instance. We use a dictionary as a
// very simple "instance manager." See also: https://github.com/flutter/plugins/tree/main/packages/webview_flutter
class NativeSegmentsHostApiIOS: NSObject, NativeSegmentsHostApi, NativeSegmentsApiManagement {
    func setSegments(id: String, segments: [NativeSegment], selectedIndex: Int32?) -> Bool {
        controller(with: id)?.setSegments(segments: segments, selectedIndex: selectedIndex?.int) ?? false
    }

    func setStyle(id: String, style: NativeSegmentsApiStyle) -> Bool {
        controller(with: id)?.setStyle(style: style) ?? false
    }

    func setSelected(id: String, index: Int32?) -> Bool {
        print("TODO: set selected! \(id) \(index)")
        return false

    }

    // Stored property required by `SegmentsApiManagement`.
    var controllers: [String : Weak<NativeSegmentsViewController>] = [:]
}

// Separate internal management functions from the Host API to make API maintenance easier.
protocol NativeSegmentsApiManagement: NativeSegmentsHostApiIOS {
    // Retain a weak reference to each view for dispatching API events properly,
    // since Pigeon does not yet support multiple API instances/channels.
    // Weak references allow the framework to dispose of views when it wants to.
    var controllers: [String: Weak<NativeSegmentsViewController>] { get set }

    func register(controller: NativeSegmentsViewController)
    func deregister(controller: NativeSegmentsViewController)

    // Convenience method to delegate calls to the registered view by its ID.
    func controller(with id: String) -> NativeSegmentsViewController?
}

extension NativeSegmentsApiManagement {
    func register(controller: NativeSegmentsViewController) {
        controllers[controller.id] = Weak(value: controller)
    }

    func deregister(controller: NativeSegmentsViewController) {
        controllers.removeValue(forKey: controller.id)
    }

    func controller(with id: String) -> NativeSegmentsViewController? {
        controllers[id]?.value
    }
}
