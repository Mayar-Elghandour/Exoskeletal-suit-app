import 'package:exoskeleton_suit_app/Settings.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/Beginner.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'UserProfile.dart';
import 'bluetooth_managerrr2.dart';
import 'generated/app_localizations.dart';
import 'Bluetooth_connection.dart';
import 'eye_did.dart';
import 'gaze_cursor_overlay.dart';
import 'package:flutter/rendering.dart';

class BasicModes extends StatefulWidget {
  const BasicModes({Key? key}) : super(key: key);

  @override
  State<BasicModes> createState() => _BasicModesState();
}

class _BasicModesState extends State<BasicModes> {
  Offset? _gazePosition;

  @override
  void initState() {
    super.initState();
    BluetoothManager().autoConnectIfPossible();

    EyeTrackingService().gazeNotifier.addListener(() {
      if (mounted) {
        setState(() {
          _gazePosition = EyeTrackingService().gazeNotifier.value;
        });
      }
    });

    EyeTrackingService().dwellStream.listen((gazePosition) {
      if (mounted) _handleDwellTrigger(gazePosition);
    });
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

  Widget _gazeButton({required String label, required VoidCallback onPressed}) {
    return MetaData(
      metaData: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(241, 255, 255, 255),
          elevation: 4,
        ),
        child: Text(
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: SafeArea(
            child: Stack(
              children: [
                // Top-right Settings icon with gaze
               /*Positioned(
                top: 20,
                right: 2, // use `right` instead of `left: screenWidth - 55`
                child: MetaData(
                  metaData: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  Settings()),
                    );
                    print('Navigating to Settings');
                  },
                  behavior: HitTestBehavior.opaque,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  Settings()),
                      );
                      print('Navigating to Settings');
                    },
                    child: const Icon(
                      Icons.settings,
                      size: 60,
                      color: Color(0xff98C5EE),
                    ),
                  ),
                ),
              ),
*/

                // Title
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.modes,
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Federant',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Buttons
                Positioned(
                  top: 200,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                    decoration: BoxDecoration(
                      color: const Color(0xff98C5EE),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(1000),
                        topRight: Radius.circular(1000),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF98C5EE).withOpacity(0.72),
                          offset: const Offset(0, -50),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _gazeButton(
                          label: AppLocalizations.of(context)!.beginner,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const Beginner()));
                          },
                        ),
                        const SizedBox(height: 50),
                        _gazeButton(
                          label: AppLocalizations.of(context)!.advanced,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const Advanced()));
                          },
                        ),
                        const SizedBox(height: 50),
                        _gazeButton(
                          label: AppLocalizations.of(context)!.user_profile,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const UserProfile()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const GazeCursorOverlay(), // always on top
      ],
    );
  }
}
