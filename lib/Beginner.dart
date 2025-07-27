import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/eye_did.dart';
import 'package:exoskeleton_suit_app/gaze_cursor_overlay.dart';
import 'package:flutter/rendering.dart';
import 'generated/app_localizations.dart';

class Beginner extends StatefulWidget {
  const Beginner({super.key});

  @override
  State<Beginner> createState() => _BeginnerState();
}

class _BeginnerState extends State<Beginner> {
  Offset? _gazePosition;

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

    EyeTrackingService().dwellStream.listen((gazePosition) {
      if (mounted) {
        _handleDwellTrigger(gazePosition);
      }
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                // Background Image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Top semi-circle background
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.62,
                    decoration: BoxDecoration(
                      color: const Color(0xff98C5EE),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(1000),
                        bottomRight: Radius.circular(1000),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF98C5EE).withOpacity(0.72),
                          offset: const Offset(0, 20),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Left Circle
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

                // Back Icon with gaze support
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
                    child: Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: const Color(0xff98C5EE),
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
                        MaterialPageRoute(builder: (context) => const Advanced()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Advanced()),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 50,
                        color: Color(0xff98C5EE),
                      ),
                    ),
                  ),
                ),

                // Top Right Circle
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
                // Home Icon with both dwell and normal tap support
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BasicModes()),
                        );
                      },
                      child: const Icon(
                        Icons.home_outlined,
                        size: 50,
                        color: Color(0xff98C5EE),
                      ),
                    ),
                  ),
                ),


                // Title
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.instructions,
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Federant',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Instructions Text
                Padding(
                  padding: const EdgeInsets.only(top: 150, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.for_grabbing,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff062E85),
                          fontFamily: 'Federant',
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.think_of_your_right_hand,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: 'Federant',
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.for_elbow_up,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff062E85),
                          fontFamily: 'Federant',
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.think_of_your_left_hand,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: 'Federant',
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.for_elbow_down,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff062E85),
                          fontFamily: 'Federant',
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.think_neutrally,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: 'Federant',
                        ),
                      ),
                    ],
                  ),
                ),

                // Image and Get Started Button
                Positioned(
                  top: screenHeight * 0.55,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Image.asset(
                          'assets/images/Screenshot 2025-05-01 182307.png',
                          height: screenHeight * 0.15,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      MetaData(
                        metaData: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Advanced()),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Advanced()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff98C5EE),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.get_started,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'Golos_Text',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
