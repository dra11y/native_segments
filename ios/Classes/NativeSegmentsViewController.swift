//
//  NativeSegmentsView.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/22/22.
//

import Flutter
import Foundation

// Provides a public interface for the methods our view controller provides.
protocol NativeSegmentsViewControllerApi {
    var id: String { get }
    func setSegments(segments: [NativeSegment], selectedIndex: Int?) -> Bool
    func setStyle(style: NativeSegmentsApiStyle) -> Bool
}

// Implements `FlutterPlatformView` and really acts more like a view controller than a view.
class NativeSegmentsViewController: NSObject, FlutterPlatformView, NativeSegmentsViewControllerApi {
    public let viewId: Int64
    public let id: String

    init(frame: CGRect, id: String, viewId: Int64, hostApi: NativeSegmentsHostApiIOS, flutterApi: NativeSegmentsFlutterApi) {
        self.id = id
        self.viewId = viewId
        self.hostApi = hostApi
        self.flutterApi = flutterApi
        uiView = MySegmentedControl(frame: frame)

        super.init()

        uiView.heightChanged = { height in
            // Callback to Flutter framework with the control's desired height so
            // it can update its `SizedBox` for dynamic type.
            flutterApi.wantsHeight(id: id, height: height) {}
        }

        hostApi.register(controller: self)
    }

    deinit {
        hostApi.deregister(controller: self)
    }

    func view() -> UIView {
        uiView
    }

    private let hostApi: NativeSegmentsHostApiIOS
    private let flutterApi: NativeSegmentsFlutterApi
    private let uiView: MySegmentedControl

    func setSegments(segments: [NativeSegment], selectedIndex: Int?) -> Bool {
        uiView.removeAllSegments()
        for (index, segment) in segments.enumerated() {
            uiView.insertSegment(withTitle: segment.title, at: index, animated: false)
        }
        uiView.selectedSegmentIndex = selectedIndex ?? UISegmentedControl.noSegment
        uiView.addTarget(self, action: #selector(valueSelected), for: .valueChanged)
        return true
    }

    @objc func valueSelected(_ control: UISegmentedControl) {
        flutterApi.valueChanged(id: id, selectedIndex: control.selectedSegmentIndex.int32) {}
    }

    func setStyle(style: NativeSegmentsApiStyle) -> Bool {
        uiView.setStyle(style: style)
        return true
    }
}
