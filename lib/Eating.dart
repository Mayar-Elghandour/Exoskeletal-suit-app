import 'package:exoskeleton_suit_app/Manual.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'generated/app_localizations.dart';
import 'eye_did.dart'; // 👁️ EyeTrackingService import
import 'package:flutter/rendering.dart';
import 'gaze_cursor_overlay.dart'; // 👁️ GazeCursorOverlay import

class Eating extends StatefulWidget {
  const Eating({Key? key}) : super(key: key);

  @override
  State<Eating> createState() => _EatingState();
}

class _EatingState extends State<Eating> {
  Interpreter? interpreter;
  bool isModelLoaded = false;
  bool isRunning = false;
  String? currentPrediction;

  @override
  void initState() {
    super.initState();

    // 👁️ Gaze dwell listener
    EyeTrackingService().dwellStream.listen((gazePosition) {
      _handleDwellTrigger(gazePosition);
    });
  }

  // 🔍 Trigger action when gaze dwells on a MetaData-wrapped widget
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xff98C5EE),
          body: SafeArea(
            child: Stack(
              children: [
                // UI decorations and header
                ...[
                  Positioned(
                    top: -50,
                    left: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF98C5EE).withOpacity(0.72),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ⬅️ Back icon (tap + gaze)
                  Positioned(
                    top: 10,
                    left: 5,
                    child: MetaData(
                      metaData: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Advanced()),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 50, color: Color(0xff98C5EE)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Advanced()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -50,
                    left: screenWidth - 75,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF98C5EE).withOpacity(0.72),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🏠 Home icon (tap + gaze)
                  Positioned(
                    top: 5,
                    left: screenWidth - 55,
                    child: MetaData(
                      metaData: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BasicModes()),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: IconButton(
                        icon: const Icon(Icons.home_outlined, size: 50, color: Color(0xff98C5EE)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const BasicModes()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],

                // 🧠 Title
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.eating,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Federant',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // 🍽️ Turn Off button (tap + gaze)
                Positioned(
                  top: 250,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: MetaData(
                      metaData: () {
                        BluetoothManager().sendData("0", context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Manual()),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: ElevatedButton(
                        onPressed: () {
                          BluetoothManager().sendData("0", context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Manual()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          backgroundColor: const Color(0xff062E85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.turn_off,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ℹ️ Bottom info container
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(2000)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 194, 220, 245).withOpacity(0.72),
                          offset: const Offset(0, -50),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.note_To_switch_to_another_mode_turn_off_eating_mode,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Pacifico',
                              color: Color(0xff062E85),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 👁️ Gaze pointer overlay
        const GazeCursorOverlay(),
      ],
    );
  }
}
