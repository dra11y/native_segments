// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import './native_segments_platform_interface.dart';

/// The Android implementation of [SegmentsPlatform].
class NativeSegmentsAndroid extends NativeSegmentsPlatform {
  /// Registers this class as the default instance of [SegmentsPlatform]
  static void registerWith() {
    NativeSegmentsPlatform.instance = NativeSegmentsAndroid();
  }

  @override
  // https://material.io/components/tabs/android#scrollable-tabs
  // Material: "48dp (inline text) or 72dp (non-inline text and icon)"
  double get defaultHeight => 48;

  @override
  String get viewType => 'com.dra11y.flutter.native_segments.android';

  Map<String, dynamic> creationParams = <String, dynamic>{};

  @override
  Widget buildPlatformWidget(NativeSegmentsState state, BuildContext context) {
    return AndroidView(
      viewType: viewType,
      creationParamsCodec: const JSONMessageCodec(),
      creationParams: {
        'id': state.id,
      },
      onPlatformViewCreated: (viewId) async => onPlatformViewCreated(
        id: state.id,
        viewId: viewId,
        state: state,
        context: context,
      ),
    );
  }
}
