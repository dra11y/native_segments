// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import './pigeons.g.dart';
import './native_segments.dart';

export './pigeons.g.dart'
    show
        NativeSegmentsHostApi,
        NativeSegmentsFlutterApi,
        NativeSegmentsApiStyle,
        RGBAColor,
        NativeSegment;
export './native_segments.dart';

/// The interface that implementations of `segments` must implement.
///
/// Platform implementations must **extend** this class rather than implement it
/// as `segments` does not consider newly added methods to be breaking changes.
///
/// This is because of the differences between:
/// - Extending this class (using `extends`): implementation gets default
/// implementation, so no work is needed except updating the dependency version.
/// - Implementing this class (using `implements`): interface will be broken
/// by newly added methods, meaning more code to be added (more work),
/// but custom implementation (more control).

class _PlaceholderImplementation extends NativeSegmentsPlatform {}

abstract class NativeSegmentsPlatform extends PlatformInterface
    implements NativeSegmentsFlutterApi {
  NativeSegmentsPlatform({double? defaultHeight})
      : this.defaultHeight = defaultHeight ?? 32.0,
        super(token: _token);

  static final Object _token = Object();

  /// The default instance of [SegmentsPlatform] to use.
  ///
  /// Defaults to [SegmentsPlatform] implemented in `segments_platform_interface`.
  static NativeSegmentsPlatform _instance = _PlaceholderImplementation();

  /// The instance of [SegmentsPlatform] to use.
  ///
  /// Defaults to a placeholder that does not override any methods, and thus
  /// throws `UnimplementedError` in most cases.
  static NativeSegmentsPlatform get instance => _instance;

  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [SegmentsPlatform] when they
  /// register themselves.
  static set instance(NativeSegmentsPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Pigeon currently only supports a single API channel/instance. Therefore, we must
  /// "register" each instance of the component with our singleton API instance (exactly
  /// the same as on the host side) so we can pass messages to the proper component instance.
  Map<String, NativeSegmentsState> _widgetInstances = {};

  void register(NativeSegmentsState state) {
    if (!isFlutterApiSetup) {
      NativeSegmentsFlutterApi.setup(this);
      isFlutterApiSetup = true;
    }

    _widgetInstances[state.id] = state;
  }

  void deregister(NativeSegmentsState state) {
    _widgetInstances.remove(state.id);
  }

  bool isFlutterApiSetup = false;

  NativeSegmentsHostApi api = NativeSegmentsHostApi();

  @override
  void wantsHeight(String id, double height) {
    _widgetInstances[id]?.setWantedHeight(height);
  }

  @override
  void valueChanged(String id, int selectedIndex) {
    _widgetInstances[id]?.onValueChanged(selectedIndex);
  }

  @override
  void refresh(String id) {
    _widgetInstances[id]?.refresh();
  }

  // Default segmented control height for the platform.
  final double defaultHeight;

  final String viewType = 'com.dra11y.flutter.native_segments';

  Widget buildPlatformWidget(NativeSegmentsState state, BuildContext context) {
    throw UnimplementedError(
        'buildPlatformWidget() has not been implemented on this platform.');
  }

  Future<void> onPlatformViewCreated({
    required String id,
    required int viewId,
    required NativeSegmentsState state,
    required BuildContext context,
  }) async {
    register(state);
    await api.setSegments(id, state.segments, state.selectedIndex);
    await api.setStyle(id, state.widget.style.toApiStyle());
  }
}
