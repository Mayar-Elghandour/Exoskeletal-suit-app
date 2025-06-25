
import 'flutter_matlab_reader_platform_interface.dart';

class FlutterMatlabReader {
  Future<String?> getPlatformVersion() {
    return FlutterMatlabReaderPlatform.instance.getPlatformVersion();
  }
}
