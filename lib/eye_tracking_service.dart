// import 'dart:async';
// import 'dart:math';
// import 'package:eyedid_sdk/eyedid_sdk.dart';

// class EyeTrackingService {
//   static final EyeTrackingService _instance = EyeTrackingService._internal();
//   factory EyeTrackingService() => _instance;
//   EyeTrackingService._internal();

//   final StreamController<void> _blinkController = StreamController<void>.broadcast();
//   final StreamController<String> _gazeDirectionController = StreamController<String>.broadcast();

//   Stream<void> get onBlink => _blinkController.stream;
//   Stream<String> get onGazeDirection => _gazeDirectionController.stream;

//   Future<void> start() async {
//     EyedidSdk.addListener(_onEyeData);

//     await EyedidSdk.start(); // Starts camera & processing
//     print("🟢 Eyedid tracking started");
//   }

//   void _onEyeData(EyedidEvent ev) {
//     final info = MetricsInfo(ev);

//     if (info.gazeInfo.trackingState == TrackingState.success) {
//       final gaze = info.gazeInfo.gazePoint;
//       final blink = info.eyeInfo.blinkStrength;

//       // Detect blink
//       if (blink > 0.8) {
//         print("👁️ Blink detected");
//         _blinkController.add(null);
//       }

//       // Simple gaze direction logic
//       final x = gaze.x;
//       if (x < 0.3) {
//         _gazeDirectionController.add("left");
//       } else if (x > 0.7) {
//         _gazeDirectionController.add("right");
//       } else {
//         _gazeDirectionController.add("center");
//       }
//     }
//   }

//   void stop() {
//     EyedidSdk.removeListener(_onEyeData);
//     EyedidSdk.stop();
//     print("🛑 Eyedid tracking stopped");
//   }

//   void dispose() {
//     _blinkController.close();
//     _gazeDirectionController.close();
//     EyedidSdk.removeListener(_onEyeData);
//   }
// }
