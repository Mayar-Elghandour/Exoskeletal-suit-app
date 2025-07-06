import 'package:flutter/material.dart';
import 'eye_did.dart';

class GazeCursorOverlay extends StatefulWidget {
  const GazeCursorOverlay({super.key});

  @override
  State<GazeCursorOverlay> createState() => _GazeCursorOverlayState();
}

class _GazeCursorOverlayState extends State<GazeCursorOverlay> {
  Offset _cursorPosition = const Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();

    EyeTrackingService().gazeNotifier.addListener(() {
      final gaze = EyeTrackingService().gazeNotifier.value;
      if (gaze != null && mounted) {
        setState(() {
          _cursorPosition = gaze;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: _cursorPosition.dx - 15,
            top: _cursorPosition.dy - 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 244, 152, 54),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
