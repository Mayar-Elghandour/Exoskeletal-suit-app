import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:chaquopy/chaquopy.dart';
import 'generated/app_localizations.dart';
class MatChannelService {
  static const platform = MethodChannel("com.exo.xml");

  static Future<List<List<double>>> preprocessXml(String path) async {
    if (path.isEmpty) {
      throw Exception("path is empty");
    } else {
      print("📎 Path from Flutter at methodChannel: $path");

      try {
        final String jsonString = await platform.invokeMethod("preprocessXml", {
          "path": path,
        });
        List<List<double>> eeg = List<List<double>>.from(
          jsonDecode(jsonString).map((row) => List<double>.from(row)),
        );

        //print("📊 Platform channel result: $eeg");
        return List<List<double>>.from(eeg);
      } catch (e) {
        print("❌ Platform channel error: $e");
        throw Exception("path is empty");
      }
    }
  }
}
