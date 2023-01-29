// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import './native_segments_platform_interface.dart';

/// The iOS implementation of [SegmentsPlatform].
class NativeSegmentsIOS extends NativeSegmentsPlatform {
  /// Registers this class as the default instance of [SegmentsPlatform]
  static void registerWith() {
    NativeSegmentsPlatform.instance = NativeSegmentsIOS();
  }

  @override
  double get defaultHeight => 32;

  @override
  String get viewType => 'com.dra11y.flutter.native_segments.ios';

  @override
  Widget buildPlatformWidget(NativeSegmentsState state, BuildContext context) =>
      UiKitView(
        viewType: viewType,
        creationParamsCodec: const JSONMessageCodec(),
        creationParams: {
          'id': state.id,
        },
        onPlatformViewCreated: (viewId) async => onPlatformViewCreated(
            id: state.id, viewId: viewId, state: state, context: context),
      );
}
