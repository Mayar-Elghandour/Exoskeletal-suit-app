import 'dart:async';
import 'dart:math';
import 'dart:ui'; // For lerpDouble
import 'package:flutter/material.dart';
import 'package:eyedid_flutter/eyedid_flutter.dart';
import 'package:eyedid_flutter/eyedid_flutter_initialized_result.dart';
import 'package:eyedid_flutter/constants/eyedid_flutter_calibration_option.dart';
import 'package:eyedid_flutter/events/eyedid_flutter_metrics.dart';
import 'package:eyedid_flutter/events/eyedid_flutter_status.dart';
import 'package:eyedid_flutter/events/eyedid_flutter_calibration.dart';
import 'package:eyedid_flutter/events/eyedid_flutter_drop.dart';
import 'package:eyedid_flutter/gaze_tracker_options.dart';

class EyeTrackingService {
  static final EyeTrackingService _instance = EyeTrackingService._internal();
  factory EyeTrackingService() => _instance;
  EyeTrackingService._internal();

  final EyedidFlutter _eyedid = EyedidFlutter();
  final String _licenseKey = 'dev_qtadvmvbl7q1791kcpyw4ynwexowa8rq93pb2z5t';

  bool hasCameraPermission = false;
  bool isInitialized = false;
  bool isTracking = false;
  bool isCalibrating = false;

  double gazeX = 0.0;
  double gazeY = 0.0;
  Color gazeColor = Colors.red;

  double nextCalibX = 0.0;
  double nextCalibY = 0.0;
  double calibrationProgress = 0.0;

  final ValueNotifier<Offset?> gazeNotifier = ValueNotifier(null);
  final ValueNotifier<bool> calibrationNotifier = ValueNotifier(false);
  final StreamController<Offset> _dwellController = StreamController<Offset>.broadcast();
  Stream<Offset> get dwellStream => _dwellController.stream;

  StreamSubscription<dynamic>? _trackingEventSub;
  StreamSubscription<dynamic>? _dropEventSub;
  StreamSubscription<dynamic>? _statusEventSub;
  StreamSubscription<dynamic>? _calibrationEventSub;
  Timer? _periodicCalibrationTimer;
  Timer? _dwellTimer;

  Offset? _lastSmoothedOffset;
  Offset? _lastDwellTarget;
  static const Duration dwellDuration = Duration(seconds: 2);//////////////////////////////////////////////////////////////

  Future<void> initialize() async {
    await _checkPermissions();
    if (!hasCameraPermission) return;

    final options = GazeTrackerOptionsBuilder()
        .setPreset(CameraPreset.vga640x480)
        .setUseGazeFilter(true)
        .setUseBlink(false)
        .setUseUserStatus(false)
        .build();

    try {
      final result = await _eyedid.initGazeTracker(
        licenseKey: _licenseKey,
        options: options,
      );

      if (result.result) {
        isInitialized = true;
        _startTracking();
      } else if (result.message == InitializedResult.isAlreadyAttempting ||
          result.message == InitializedResult.gazeTrackerAlreadyInitialized) {
        isInitialized = true;
        final running = await _eyedid.isTracking();
        if (running) isTracking = true;
      }

      _listenEvents();
      _startPeriodicCalibration();
    } catch (e) {
      debugPrint("❌ EyeTracking init failed: $e");
    }
  }

  Future<void> _checkPermissions() async {
    try {
      hasCameraPermission = await _eyedid.checkCameraPermission();
      if (!hasCameraPermission) {
        hasCameraPermission = await _eyedid.requestCameraPermission();
      }
    } catch (e) {
      debugPrint("❌ Permission check failed: $e");
    }
  }

  void _startTracking() {
    _eyedid.startTracking();
    isTracking = true;
  }

  void stopTracking() {
    _eyedid.stopTracking();
    isTracking = false;
    _periodicCalibrationTimer?.cancel();
  }

  void _listenEvents() {
    _trackingEventSub?.cancel();
    _dropEventSub?.cancel();
    _statusEventSub?.cancel();
    _calibrationEventSub?.cancel();

    _trackingEventSub = _eyedid.getTrackingEvent().listen((event) {
      final info = MetricsInfo(event);

      if (info.gazeInfo.trackingState == TrackingState.success) {
        gazeX = info.gazeInfo.gaze.x;
        gazeY = info.gazeInfo.gaze.y;

        final screenSize = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize /
            WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

        if (gazeX < 0 || gazeY < 0) return;

        final Offset clamped = Offset(
          gazeX.clamp(0.0, screenSize.width),
          gazeY.clamp(0.0, screenSize.height),
        );

        final Offset smoothed = _smoothGaze(clamped);
        _lastSmoothedOffset = smoothed;

        gazeColor = Colors.green;
        gazeNotifier.value = smoothed;

        _handleDwell(smoothed);
      } else {
        gazeColor = Colors.red;
        gazeNotifier.value = null;
        _cancelDwell();
      }
    });

    _dropEventSub = _eyedid.getDropEvent().listen((event) {
      final info = DropInfo(event);
      debugPrint("Dropped: \${info.timestamp}");
    });

    _statusEventSub = _eyedid.getStatusEvent().listen((event) {
      final info = StatusInfo(event);
      isTracking = info.type == StatusType.start;
    });

    _calibrationEventSub = _eyedid.getCalibrationEvent().listen((event) async {
      final info = CalibrationInfo(event);
      if (info.type == CalibrationType.nextPoint) {
        nextCalibX = info.next!.x;
        nextCalibY = info.next!.y;
        calibrationProgress = 0.0;
        calibrationNotifier.value = true;
        await Future.delayed(const Duration(milliseconds: 500));
        _eyedid.startCollectSamples();
      } else if (info.type == CalibrationType.progress) {
        calibrationProgress = info.progress!;
      } else if (info.type == CalibrationType.finished ||
          info.type == CalibrationType.canceled) {
        isCalibrating = false;
        calibrationNotifier.value = false;
      }
    });
  }

  void _handleDwell(Offset gaze) {
    if (_lastDwellTarget != null && (gaze - _lastDwellTarget!).distance > 50.0) {
      _cancelDwell();
    }

    _lastDwellTarget = gaze;

    _dwellTimer ??= Timer(dwellDuration, () {
      debugPrint("🕒 Dwell trigger at: \$gaze");
      _dwellController.add(gaze);
      _dwellTimer = null;
      _lastDwellTarget = null;
    });
  }

  void _cancelDwell() {
    _dwellTimer?.cancel();
    _dwellTimer = null;
    _lastDwellTarget = null;
  }

  void _startPeriodicCalibration() {
    _periodicCalibrationTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      debugPrint("🔄 Periodic calibration triggered");
      startCalibration();
    });
  }

  Offset _smoothGaze(Offset newOffset) {
    if (_lastSmoothedOffset == null) return newOffset;
    const double alpha = 0.4;
    return Offset(
      lerpDouble(_lastSmoothedOffset!.dx, newOffset.dx, alpha)!,
      lerpDouble(_lastSmoothedOffset!.dy, newOffset.dy, alpha)!,
    );
  }

  void startCalibration() {
    if (!isInitialized) return;
    isCalibrating = true;
    calibrationNotifier.value = true;
    _eyedid.startCalibration(CalibrationMode.five, usePreviousCalibration: true);
  }

  void dispose() {
    _trackingEventSub?.cancel();
    _dropEventSub?.cancel();
    _statusEventSub?.cancel();
    _calibrationEventSub?.cancel();
    _periodicCalibrationTimer?.cancel();
    _dwellTimer?.cancel();
    gazeNotifier.dispose();
    calibrationNotifier.dispose();
    _dwellController.close();
  }
}
//hello salma