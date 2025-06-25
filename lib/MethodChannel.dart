import 'package:flutter/services.dart';
import 'package:chaquopy/chaquopy.dart';

class MatChannelService {
  static const platform = MethodChannel("com.exo.xml");

  static Future<String> preprocessXml(String path) async {
    try {
      final result = await platform.invokeMethod("preprocessXml", {
        "path": path,
        "outputDir": "preprocessed_jsThis PC/realme 6/Internal shared storage/Download/preprocessed_mat/preprocessed_json",
      });
      return result; // You can return a status string like "done"
    } catch (e) {
      print("❌ Platform channel error: $e");
      return "error";
    }
  }
}

