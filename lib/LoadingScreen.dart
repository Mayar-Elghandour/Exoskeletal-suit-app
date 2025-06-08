import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exoskeleton Suit App',
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _loadingTimer;
  String _loadingText = "Loading";
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    // Loading text animation
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // Cycle between 0-3
        _loadingText = "Loading${'.' * _dotCount}";
      });
    });

    // Navigate to next screen
    Timer(const Duration(seconds: 5), () {
      _loadingTimer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BasicModes()),
      );
    });
  }

  @override
  void dispose() {
    _loadingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content: title, subtitle, image
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Title with stroke and shadow
              Stack(
                children: [
                  Center(
                    child: Text(
                      'NeuroFlex',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Golos_Text',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.white,
                        shadows: const [
                          Shadow(
                            blurRadius: 4.0,
                            color: Color(0xFF98C5EE),
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'NeuroFlex',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Golos_Text',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),
              const Text(
                "Empower movement with the power of your mind",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 38),
              Image.asset(
                'assets/images/neuroflex.png',
                width: 300,
                height: 200,
                fit: BoxFit.contain,
              ),

              const Spacer(),
            ],
          ),

          // Curved semi-circle container at the bottom
          Positioned(
            top: screenHeight * 0.65,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenWidth + 150,
              height: screenHeight * 0.65,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(1000),
                  topRight: Radius.circular(1000),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF98C5EE).withOpacity(0.72),
                    offset: const Offset(0, -20),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _loadingText, // <-- This is now animated
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 36,
                      color: Colors.indigo.shade900,
                      shadows: const [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
