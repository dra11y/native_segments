import 'dart:math';

import 'package:flutter/material.dart';
import './native_segments_platform_interface.dart';
import 'package:uuid/uuid.dart';

class NativeSegments extends StatefulWidget {
  const NativeSegments({
    Key? key,
    required this.segments,
    required this.style,
    this.onValueChanged,
    this.controller,
    this.initialSelectedIndex = 0,
  }) : super(key: key);

  final List<NativeSegment> segments;
  final int initialSelectedIndex;
  final NativeSegmentsStyle style;
  final ValueChanged<int>? onValueChanged;
  final TabController? controller;

  @override
  NativeSegmentsState createState() => NativeSegmentsState();
}

class NativeSegmentsStyle {
  const NativeSegmentsStyle({
    this.isDarkTheme,
    this.backgroundColor,
    this.backgroundColorDark,
    this.selectedSegmentColor,
    this.textColor,
    this.selectedTextColor,
    this.enableDynamicType,
    this.variableWidths,
  });

  factory NativeSegmentsStyle.fromApiStyle(NativeSegmentsApiStyle apiStyle) {
    return NativeSegmentsStyle(
      isDarkTheme: apiStyle.isDarkTheme,
      backgroundColor: apiStyle.backgroundColor?.toColor(),
      backgroundColorDark: apiStyle.backgroundColorDark?.toColor(),
      selectedSegmentColor: apiStyle.selectedSegmentColor?.toColor(),
      textColor: apiStyle.textColor?.toColor(),
      selectedTextColor: apiStyle.selectedTextColor?.toColor(),
      enableDynamicType: apiStyle.enableDynamicType,
      variableWidths: apiStyle.variableWidths,
    );
  }

  NativeSegmentsApiStyle toApiStyle() {
    return NativeSegmentsApiStyle(
      isDarkTheme: isDarkTheme,
      backgroundColor: backgroundColor?.toRGBAColor(),
      backgroundColorDark: backgroundColorDark?.toRGBAColor(),
      selectedSegmentColor: selectedSegmentColor?.toRGBAColor(),
      textColor: textColor?.toRGBAColor(),
      selectedTextColor: selectedTextColor?.toRGBAColor(),
      enableDynamicType: enableDynamicType,
      variableWidths: variableWidths,
    );
  }

  // Set `null` for light/dark mode auto-detection,
  // `true` to force dark mode, and `false` to force light mode.
  final bool? isDarkTheme;
  // Override the default background color of the entire control.
  final Color? backgroundColor;
  // Override the default background color of the entire control (Dark Mode).
  final Color? backgroundColorDark;
  // The primary color of the selected segment.
  final Color? selectedSegmentColor;
  // The color of the unselected segment's text.
  final Color? textColor;
  // The color of the selected segment's text.
  final Color? selectedTextColor;
  // Enable dynamic type adjustment. In almost all cases, leave as `true` (default).
  final bool? enableDynamicType;
  // Vary the width of each segment according to its content.
  final bool? variableWidths;
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

class NativeSegmentsState extends State<NativeSegments> {
  @override
  void dispose() {
    super.dispose();
    if (viewId > -1) {
      NativeSegmentsPlatform.instance.deregister(this);
    }
  }

  int get selectedIndex => _selectedIndex;
  // List<NativeSegment> get segments => _segments.value;
  List<NativeSegment> get segments => _segments;

  final String id = const Uuid().v4();
  int viewId = -1;
  int _selectedIndex = 0;
  double wantedHeight = NativeSegmentsPlatform.instance.defaultHeight;
  List<NativeSegment> _segments = [];
  final hostApi = NativeSegmentsHostApi();

  void setViewId(int id) {
    setState(() {
      viewId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    _segments = widget.segments;
    _selectedIndex = widget.initialSelectedIndex;
  }

  void onValueChanged(int segmentIndex) {
    setState(() {
      _selectedIndex = segmentIndex;
    });
    widget.onValueChanged?.call(segmentIndex);
    widget.controller?.index = segmentIndex;
  }

  void setWantedHeight(double height) {
    if (height == wantedHeight) return;

    setState(() {
      wantedHeight = height;
    });
  }

  Object _refreshKey = Object();

  void refresh() {
    setState(() {
      _refreshKey = Object();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey<Object>(_refreshKey),
      height: wantedHeight,
      child: NativeSegmentsPlatform.instance.buildPlatformWidget(this, context),
    );
  }
}

extension on RGBAColor {
  Color toColor() {
    return Color.fromARGB(
      (alpha ?? 0 * 255.0).toInt(),
      (red ?? 0 * 255.0).toInt(),
      (green ?? 0 * 255.0).toInt(),
      (blue ?? 0 * 255.0).toInt(),
    );
  }
}

extension on Color {
  RGBAColor toRGBAColor() {
    return RGBAColor(
      red: red / 255.0,
      green: green / 255.0,
      blue: blue / 255.0,
      alpha: alpha / 255.0,
    );
  }
}
