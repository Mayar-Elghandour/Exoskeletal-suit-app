import 'package:flutter/material.dart';
import 'eye_did.dart';
import 'dart:async';
class GazeButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String screenName; // 👈 Add this to identify the screen

  const GazeButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.screenName,
  }) : super(key: key);

  @override
  _GazeButtonState createState() => _GazeButtonState();
}

class _GazeButtonState extends State<GazeButton> {
  StreamSubscription? _dwellSub;

  @override
  void initState() {
    super.initState();
    _dwellSub = EyeTrackingService().dwellStream.listen((gazePos) {
      if (EyeTrackingService().currentScreen == widget.screenName) {
        // Now check if the gaze is over this button before triggering onPressed
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          final rect = position & size;
          if (rect.contains(gazePos)) {
            widget.onPressed();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _dwellSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
