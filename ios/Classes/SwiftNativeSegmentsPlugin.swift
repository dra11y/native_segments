//
//  SwiftSegmentsPlugin.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/22/22.
//

import Flutter
import Foundation
import ObjectiveC

public class SwiftSegmentsPlugin: NSObject, FlutterPlugin {
    static let viewTypeId = "com.dra11y.flutter.native_segments.ios"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftSegmentsPlugin(registrar: registrar)
        registrar.register(instance.factory, withId: viewTypeId)
    }

    let factory: NativeSegmentsViewFactory
    let hostApi: NativeSegmentsHostApiIOS
    let flutterApi: NativeSegmentsFlutterApi

    init(registrar: FlutterPluginRegistrar) {
        hostApi = NativeSegmentsHostApiIOS()
        NativeSegmentsHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: hostApi)
        flutterApi = NativeSegmentsFlutterApi(binaryMessenger: registrar.messenger())
        factory = NativeSegmentsViewFactory(hostApi: hostApi, flutterApi: flutterApi)

        if #available(iOS 13.0, *) {
            _ = UISegmentSwizzler()
        }
    }
}
