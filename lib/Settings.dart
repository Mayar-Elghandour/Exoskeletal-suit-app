import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Bluetooth_connection.dart';
import 'package:exoskeleton_suit_app/Language.dart';
import 'package:exoskeleton_suit_app/Themes.dart';
import 'package:exoskeleton_suit_app/gaze_cursor_overlay.dart';
import 'generated/app_localizations.dart';
import 'eye_did.dart';
import 'dart:async';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Offset? _gazePosition;
  StreamSubscription? _dwellSub;

  @override
  void initState() {
    super.initState();
    //EyeTrackingService().setCurrentScreen("Settings");

    EyeTrackingService().gazeNotifier.addListener(() {
      if (mounted) {
        setState(() {
          _gazePosition = EyeTrackingService().gazeNotifier.value;
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 1500));
    _dwellSub = EyeTrackingService().dwellStream.listen((gazePosition) {
      if (mounted) _handleDwellTrigger(gazePosition);
    });
  }

  @override
  void dispose() {
    _dwellSub?.cancel();
    EyeTrackingService().gazeNotifier.value = Offset.zero; // ✅ Clear gaze
    super.dispose();
  }

  void _handleDwellTrigger(Offset gazePosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset local = box.globalToLocal(gazePosition);
    final hitTestResult = BoxHitTestResult();
    WidgetsBinding.instance.hitTest(hitTestResult, local);

    for (final result in hitTestResult.path) {
      final target = result.target;
      if (target is RenderMetaData && target.metaData is VoidCallback) {
        (target.metaData as VoidCallback)();
        break;
      }
    }
  }

  Widget _gazeButton({required String label, required VoidCallback onPressed, Widget? icon}) {
    return MetaData(
      metaData: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ElevatedButton(
        onPressed: onPressed,
        child: icon ?? Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'Federant',
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return _gazeButton(
      onPressed: onTap,
      label: title,
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF98C5EE)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 25),
              ),
            ),
            const Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF98C5EE),
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: _gazeButton(
              label: '',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BasicModes()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Color(0xff98c5ee)),
            ),
            title: Text(
              AppLocalizations.of(context)!.settings,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xff98c5ee),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
            child: ListView(
              children: [
                _buildRoundedTile(
                  icon: Icons.bluetooth,
                  title: AppLocalizations.of(context)!.bluetooth_connection,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BluetoothPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                const SizedBox(height: 20),
                _buildRoundedTile(
                  icon: Icons.color_lens,
                  title: AppLocalizations.of(context)!.themes,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ThemePage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                const SizedBox(height: 20),
                _buildRoundedTile(
                  icon: Icons.language,
                  title: AppLocalizations.of(context)!.language,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguagePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const GazeCursorOverlay(),
      ],
    );
  }
}
