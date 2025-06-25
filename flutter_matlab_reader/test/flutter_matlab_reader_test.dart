import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_matlab_reader/flutter_matlab_reader.dart';
import 'package:flutter_matlab_reader/flutter_matlab_reader_platform_interface.dart';
import 'package:flutter_matlab_reader/flutter_matlab_reader_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMatlabReaderPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMatlabReaderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMatlabReaderPlatform initialPlatform = FlutterMatlabReaderPlatform.instance;

  test('$MethodChannelFlutterMatlabReader is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMatlabReader>());
  });

  test('getPlatformVersion', () async {
    FlutterMatlabReader flutterMatlabReaderPlugin = FlutterMatlabReader();
    MockFlutterMatlabReaderPlatform fakePlatform = MockFlutterMatlabReaderPlatform();
    FlutterMatlabReaderPlatform.instance = fakePlatform;

    expect(await flutterMatlabReaderPlugin.getPlatformVersion(), '42');
  });
}
