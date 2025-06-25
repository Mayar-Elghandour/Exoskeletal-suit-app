import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_matlab_reader_method_channel.dart';

abstract class FlutterMatlabReaderPlatform extends PlatformInterface {
  /// Constructs a FlutterMatlabReaderPlatform.
  FlutterMatlabReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMatlabReaderPlatform _instance = MethodChannelFlutterMatlabReader();

  /// The default instance of [FlutterMatlabReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMatlabReader].
  static FlutterMatlabReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMatlabReaderPlatform] when
  /// they register themselves.
  static set instance(FlutterMatlabReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
