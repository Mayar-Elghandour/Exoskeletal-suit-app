import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Eating.dart';
import 'package:exoskeleton_suit_app/Reading.dart';
import 'package:exoskeleton_suit_app/Rehabilation.dart';
import 'package:exoskeleton_suit_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
import 'package:exoskeleton_suit_app/gaze_cursor_overlay.dart';
import 'package:exoskeleton_suit_app/eye_did.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';


class Manual extends StatefulWidget {
  const Manual({Key? key}) : super(key: key);

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  Offset? _gazePosition;
  late final StreamSubscription<Offset> _dwellSub;

  @override
  void initState() {
    super.initState();

    EyeTrackingService().gazeNotifier.addListener(() {
      if (mounted) {
        setState(() {
          _gazePosition = EyeTrackingService().gazeNotifier.value;
        });
      }
    });

    _dwellSub = EyeTrackingService().dwellStream.listen((gazePosition) {
      if (mounted) {
        _handleDwellTrigger(gazePosition);
      }
    });
  }

  @override
  void dispose() {
    _dwellSub.cancel();
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

  Widget _gazeButton({required String label, required VoidCallback onPressed}) {
    return MetaData(
      metaData: onPressed,
      behavior: HitTestBehavior.opaque,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                // Decorations
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF98C5EE),
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
                
               // Back Icon with both dwell and normal tap support
                Positioned(
                  top: 10,
                  left: 5,
                  child: MetaData(
                    metaData: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const BasicModes()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BasicModes()),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 50,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
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
                      color: const Color(0xFF98C5EE),
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
                // Home Icon with both dwell and normal tap support
               Positioned(
                  top: 10,
                  right: 5,
                  child: MetaData(
                    metaData: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const BasicModes()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BasicModes()),
                        );
                      },
                      child: const Icon(
                        Icons.home_outlined,
                        size: 40,
                        color: Color.fromARGB(255, 255, 255, 255), // Easier to see
                      ),
                    ),
                  ),
                ),


                // Title
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.manual_modes,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Federant',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Button container
                Positioned(
                  top: 280,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                    decoration: BoxDecoration(
                      color: const Color(0xFF98C5EE),
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
                          label: AppLocalizations.of(context)!.eating,
                          onPressed: () {
                            BluetoothManager().sendData("e", context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Eating()));
                          },
                        ),
                        const SizedBox(height: 40),
                        _gazeButton(
                          label: AppLocalizations.of(context)!.reading,
                          onPressed: () {
                            BluetoothManager().sendData("d", context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Reading()));
                          },
                        ),
                        const SizedBox(height: 40),
                        _gazeButton(
                          label: AppLocalizations.of(context)!.rehabilation,
                          onPressed: () {
                            BluetoothManager().sendData("r", context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Rehabilation()));
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

        // Gaze-based cursor overlay
        const GazeCursorOverlay(),
      ],
    );
  }
}
