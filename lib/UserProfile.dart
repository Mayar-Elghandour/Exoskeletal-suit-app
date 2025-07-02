import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:flutter/material.dart';
import 'generated/app_localizations.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
import 'dart:convert';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  double reading_position = 50;
  double eating_position = 50;
  double elbow_min = 50;
  double elbow_max = 50;

 void sendSliders() {
  final message = jsonEncode({
    "elbow_min": elbow_min.toInt(),
    "elbow_max": elbow_max.toInt(),
    "reading": reading_position.toInt(),
    "eating": eating_position.toInt(),
  });

  BluetoothManager().sendData(message, context);
  print("📤 Sent: $message");
}



  Widget buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          label: value.toStringAsFixed(0),
          activeColor: Colors.white,
          inactiveColor: Colors.white38,
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
  top: -60,
  left: -60,
  child: Container(
    width: 150,
    height: 150,
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


            // Top-left circle
           Positioned(
              top: 10, // Moves it up off the top edge
              left: 10, // Moves it left off the screen
             
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
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),



            
Positioned(
  top: -60,
  left: MediaQuery.of(context).size.width- 95,
  child: Container(
    width: 150,
    height: 150,
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

// home icon
            Positioned(
              top: 10, // Moves it up off the top edge
              left: MediaQuery.of(context).size.width -71 , // Moves it left off the screen
             
              child: IconButton(
                icon: const Icon(
                  Icons.home_outlined,
                  size: 60, // Adjust size to fit inside the circle
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  // Navigate to the first page (assuming HomePage is the first page)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicModes()),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
            // Title
             Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.user_profile,
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Federant',
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Semi-circular background
            Positioned(
              top: screenHeight * 0.25,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      const SizedBox(height: 80),
                    buildSlider(AppLocalizations.of(context)!.elbow_min, elbow_min, (value) {
      setState(() => elbow_min = value);
      sendSliders();
    }),
    buildSlider(AppLocalizations.of(context)!.elbow_max, elbow_max, (value) {
      setState(() => elbow_max = value);
      sendSliders();
    }),
    buildSlider(AppLocalizations.of(context)!.reading_position, reading_position, (value) {
      setState(() => reading_position = value);
      sendSliders();
    }),
    buildSlider(AppLocalizations.of(context)!.eating_drinking, eating_position, (value) {
      setState(() => eating_position = value);
      sendSliders();
    }),
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
