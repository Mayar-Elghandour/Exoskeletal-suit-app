import 'package:exoskeleton_suit_app/Manual.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'generated/app_localizations.dart';
import 'eye_did.dart';
import 'gaze_cursor_overlay.dart';
import 'package:flutter/rendering.dart';

class Reading extends StatefulWidget {
  const Reading({Key? key}) : super(key: key);

  @override
  State<Reading> createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  Interpreter? interpreter;
  bool isModelLoaded = false;
  bool isRunning = false;
  String? currentPrediction;

  @override
  void initState() {
    super.initState();

    // Gaze interaction
    EyeTrackingService().dwellStream.listen((gazePosition) {
      _handleDwellTrigger(gazePosition);
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xff98C5EE),
          body: SafeArea(
            child: Stack(
              children: [
                // Background decorations
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
                          color: Color(0xFF98C5EE).withOpacity(0.72),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),

                // ⬅️ Back Button with MetaData
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
                      icon: Icon(Icons.arrow_back, size: 50, color: Color(0xff98C5EE)),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Advanced()),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),

                // 🎯 Home Icon with MetaData
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
                          color: Color(0xFF98C5EE).withOpacity(0.72),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),

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
                      icon: Icon(Icons.home_outlined, size: 50, color: Color(0xff98C5EE)),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BasicModes()),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),

                // 📖 Title
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.reading,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Federant',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // 🔘 Turn off button with gaze
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
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          backgroundColor: Color(0xff062E85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.turn_off,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ℹ️ Info Box
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(2000)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 194, 220, 245).withOpacity(0.72),
                          offset: Offset(0, -50),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 45),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .note_To_switch_to_another_mode_turn_off_reading_mode,
                            style: TextStyle(
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

        // 👁️ Gaze Cursor Feedback
        const GazeCursorOverlay(),
      ],
    );
  }
}
