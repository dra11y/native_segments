import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: './lib/src/pigeons.g.dart',
    swiftOut: './ios/Classes/GeneratedPigeons.swift',
    kotlinOut:
        './android/src/main/kotlin/com/dra11y/flutter/native_segments/GeneratedPigeons.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.dra11y.flutter.native_segments',
    ),
  ),
)
class NativeSegment {
  String? title;
}

class RGBAColor {
  double? red;
  double? green;
  double? blue;
  double? alpha;
}

class NativeSegmentsApiStyle {
  bool? isDarkTheme;
  RGBAColor? backgroundColor;
  RGBAColor? backgroundColorDark;
  RGBAColor? selectedSegmentColor;
  RGBAColor? textColor;
  RGBAColor? selectedTextColor;
  bool? enableDynamicType;
  bool? variableWidths;
}

@FlutterApi()
abstract class NativeSegmentsFlutterApi {
  void wantsHeight(String id, double height);
  void valueChanged(String id, int selectedIndex);
  void refresh(String id);
}

// Until Flutter team fixes the following issue, methods returning `void` generate errors:
// https://github.com/flutter/flutter/issues/111083
@HostApi()
abstract class NativeSegmentsHostApi {
  /// Pigeon currently only supports one channel and one shared API instance.
  /// Therefore, we must register our state IDs with the API on the native side
  /// and send commands to the appropriate state by its instance id, otherwise
  /// all commands are sent to the final view instance on the screen.
  bool setSegments(String id, List<NativeSegment> segments, int? selectedIndex);

  bool setStyle(String id, NativeSegmentsApiStyle style);

  bool setSelected(String id, int? index);
}
