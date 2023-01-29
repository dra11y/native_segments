//
//  NativeSegmentsViewFactory.swift
//  segments_ios
//
//  Created by Grushka, Tom on 9/22/22.
//

import Flutter
import Foundation

class NativeSegmentsViewFactory: NSObject, FlutterPlatformViewFactory {
    let hostApi: NativeSegmentsHostApiIOS
    let flutterApi: NativeSegmentsFlutterApi

    init(hostApi: NativeSegmentsHostApiIOS, flutterApi: NativeSegmentsFlutterApi) {
        self.hostApi = hostApi
        self.flutterApi = flutterApi
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterJSONMessageCodec()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        guard
            let args = args as? [String : Any?],
            let id = args["id"] as? String
        else {
            preconditionFailure("Instance ID must be passed from Flutter via JSONMessageCodec as { 'id': String }")
        }
        return NativeSegmentsViewController(frame: frame, id: id, viewId: viewId, hostApi: hostApi, flutterApi: flutterApi)
    }
}
