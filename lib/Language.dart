import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Settings.dart';
import 'package:flutter/material.dart';
import 'locale_controller.dart';
import 'generated/app_localizations.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return
     Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  color: Color(0xff98C5EE),
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

            // Top-left arrow
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
                    MaterialPageRoute(builder: (context) => const Settings()),
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
                  color: Color(0xff98C5EE),
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
                  AppLocalizations.of(context)!.choose_language,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                decoration: BoxDecoration(
                  color: Color(0xff98C5EE),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(260),
                    topRight: Radius.circular(260),
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
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: ()  {
                         LocaleController().setLocale(const Locale('en'));
                Navigator.pop(context);
              },
                       
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              const Color.fromARGB(241, 255, 255, 255),
                          elevation: 4,
                        ),
                        child:  Text("English",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Federant',
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      ElevatedButton(
                        onPressed: () {
                  LocaleController().setLocale(const Locale('ar'));
                Navigator.pop(context);
             
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              const Color.fromARGB(241, 255, 255, 255),
                          elevation: 4,
                        ),
                        child: 
                          const Text("العربية",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Federant',
                          ),
                        ),
                      ),
                      //const SizedBox(height: 50),
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