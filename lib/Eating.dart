import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'generated/app_localizations.dart';


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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff98C5EE),
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
                        color: Color(0xFF98C5EE).withOpacity(0.72),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      size: 50, color: Color(0xff98C5EE)),
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
                child: IconButton(
                  icon: Icon(Icons.home_outlined,
                      size: 50, color: Color(0xff98C5EE)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BasicModes()),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
            ],

            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.eating,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Federant',
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Center(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Advanced()),
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
              )),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(2000)),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 194, 220, 245).withOpacity(0.72),
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
                        AppLocalizations.of(context)!.note_To_switch_to_another_mode_turn_off_eating_mode,
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
    );
  }
}
