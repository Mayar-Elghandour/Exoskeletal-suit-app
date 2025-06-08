import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:flutter/material.dart';

class Automatic extends StatefulWidget {
  const Automatic({Key? key}) : super(key: key);

  @override
  State<Automatic> createState() => _AutomaticState();
}

class _AutomaticState extends State<Automatic> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff98C5EE),
      body: SafeArea(
        child: Stack(
          children: [
            // Left semi-circle
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
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

            // Arrow icon
            Positioned(
              top: 10,
              left: 5,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Color(0xff98C5EE),
                ),
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

            // Top Right Circle
            Positioned(
              top: -50,
              left: screenWidth - 75,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
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

            // Home Icon
            Positioned(
              top: 5,
              left: screenWidth - 55,
              child: IconButton(
                icon: const Icon(
                  Icons.home_outlined,
                  size: 50,
                  color: Color(0xff98C5EE),
                ),
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

            // Modes title above the container
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Automatic',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Federant',
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),

            // Button below the title
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Replace with your actual functionality
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
                    'on going...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Main content container
            Positioned(
              top: 380,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(2000),
                  ),
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
'''Note:
To switch to another mode, turn off automatic mode.''',
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
