import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:flutter/material.dart';
import 'generated/app_localizations.dart';

class Beginner extends StatefulWidget {
  const Beginner({super.key});

  @override
  State<Beginner> createState() => _BeginnerState();
}

class _BeginnerState extends State<Beginner> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Exoskeleton Suit App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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

              // Inverted Semi-Circle Background from Top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.62,
                  width: screenWidth,
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

              // Back Icon
              Positioned(
                top: 10,
                left: 5,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: const Color(0xff98C5EE),
                  ),
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
                      MaterialPageRoute(
                          builder: (context) => const BasicModes()),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
                    style: TextStyle(
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
                  children:  [
                    Text(
                      AppLocalizations.of(context)!.for_grabbing,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff062E85),
                        fontFamily: 'Federant',
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.think_of_your_right_hand,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Federant',
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.for_elbow_up,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff062E85),
                        fontFamily: 'Federant',
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.think_of_your_left_hand,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Federant',
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.for_elbow_down,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff062E85),
                        fontFamily: 'Federant',
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.think_neutrally,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Federant',
                      ),
                    ),
                  ],
                ),
              ),

              // Positioned image and "Get Started" button
              Positioned(
                top: screenHeight * 0.55,
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Image.asset(
                        'assets/images/Screenshot 2025-05-01 182307.png', // Replace with your image
                        height: screenHeight * 0.15,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Advanced()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff98C5EE),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child:  Text(
                        AppLocalizations.of(context)!.get_started,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Golos_Text',
                          color: Colors.white,
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
    );
  }
}
