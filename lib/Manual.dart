import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Eating.dart';
import 'package:exoskeleton_suit_app/Reading.dart';
import 'package:exoskeleton_suit_app/Rehabilation.dart';
import 'package:flutter/material.dart';

class Manual extends StatefulWidget {
  const Manual({Key? key}) : super(key: key);

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [


//left semi circle
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
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

            // Top-left circle
            Positioned(
              top: 10, // Moves it up off the top edge
              left: 5, // Moves it left off the screen

              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 50, // Adjust size to fit inside the circle
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  // Navigate to the first page (assuming HomePage is the first page)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicModes()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Automatic mode activated!')),
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
                  color: Colors.blue[300],
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
                  color: Color.fromARGB(255, 255, 255, 255),
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
                  'Manual Modes',
                  style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Federant',
                  color: Colors.black,
                  ),
                ),
              ),
            ),

            // Main content container
            Positioned(
              top: 280, // Just below the title
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
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


                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [

                      ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Eating()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromARGB(241, 255, 255, 255),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Eating",
                      style: TextStyle(color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Federant',
                      ),
                    
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Reading()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromARGB(241, 255, 255, 255),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Reading",
                      style: TextStyle(color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Federant',
                      ),
                    
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Rehabilation()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromARGB(241, 255, 255, 255),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Rehabilation",
                      style: TextStyle(color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Federant',
                      ),
                    
                    ),
                  ),
                  
                  
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
