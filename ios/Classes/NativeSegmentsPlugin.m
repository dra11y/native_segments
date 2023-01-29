#import "NativeSegmentsPlugin.h"
#if __has_include(<native_segments/native_segments-Swift.h>)
#import <native_segments/native_segments-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_segments-Swift.h"
#endif

@implementation NativeSegmentsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
   [SwiftSegmentsPlugin registerWithRegistrar:registrar];
}

@end
