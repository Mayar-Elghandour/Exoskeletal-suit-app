// lib/gaze_cursor_manager.dart
import 'package:flutter/material.dart';
import 'gaze_cursor_overlay.dart';

class GazeCursorManager {
  static final GazeCursorManager _instance = GazeCursorManager._internal();
  factory GazeCursorManager() => _instance;
  GazeCursorManager._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(builder: (_) => const GazeCursorOverlay());
    final overlay = Overlay.of(context, rootOverlay: true);
    overlay?.insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
