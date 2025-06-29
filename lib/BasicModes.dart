import 'package:exoskeleton_suit_app/Settings.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/Beginner.dart';
import 'UserProfile.dart';
import 'bluetooth_managerrr2.dart';
import 'generated/app_localizations.dart';


class BasicModes extends StatefulWidget {
  const BasicModes({Key? key}) : super(key: key);

  @override
  State<BasicModes> createState() => _BasicModesState();
  
}

class _BasicModesState extends State<BasicModes> {
  @override
  void initState() {
    super.initState();
     // Auto-connect attempt
     BluetoothManager().autoConnectIfPossible();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Stack(
          children: [

            Positioned(
              top: 5,
              left: screenWidth - 55,
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  size: 50,
                  color: Color(0xff98C5EE),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),

            // Modes title above the container
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(AppLocalizations.of(context)!.modes,
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Federant',
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Main content container
            Positioned(
              top: 200, // Just below the title
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                decoration: BoxDecoration(
                  color:  Color(0xff98C5EE),
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
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Beginner()));
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
                        child:  Text(
                          AppLocalizations.of(context)!.beginner,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Federant',
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Advanced()));
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
                        child:  Text(
                          AppLocalizations.of(context)!.advanced,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Federant',
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserProfile()));
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
                        child:  Text(
                          AppLocalizations.of(context)!.user_profile,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Federant',
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
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
