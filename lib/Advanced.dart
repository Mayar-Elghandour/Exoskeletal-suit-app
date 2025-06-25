import 'package:exoskeleton_suit_app/Automatic.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Bluetooth_connection.dart';
import 'package:exoskeleton_suit_app/Manual.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/bluetooth_manager.dart';
// import 'package:exoskeleton_suit_app/mat_processing_automatic.dart';

class Advanced extends StatefulWidget {
  const Advanced({Key? key}) : super(key: key);

  @override
  State<Advanced> createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
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
                  'Advanced Modes',
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
                        onPressed: () async {
                          if (BluetoothManager().isConnected) {
                            // ✅ Send if connected
                            await BluetoothManager().sendData(
                              "hi you are on the automatic mode",
                              context,
                            );
                            print("✅ Data sent to device.'hi you are on the automatic mode'");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Automatic()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Automatic mode activated!')),
                            );

                            return;
                          }

                          // ❌ Not connected → Show dialog to go to Bluetooth page
                          final shouldConnect = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Bluetooth Not Connected"),
                              content: const Text(
                                  "Please connect to a Bluetooth device before sending data."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // Proceed to Bluetooth page
                                  },
                                  child: const Text("Go to Bluetooth Page"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                          );

                          if (shouldConnect == true) {
                            final connected = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BluetoothPage()),
                            );

                            //await Future.delayed(const Duration(milliseconds: 200));

                            if (connected == true &&
                                BluetoothManager().isConnected) {
                              // ✅ Connected after returning — proceed
                              await BluetoothManager().sendData(
                                "hi you are on the automatic mode",
                                context,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Automatic()),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Automatic mode activated!')),
                              );
                            } else {
                              // ❌ Still not connected
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "⚠️ Still not connected to a device")),
                              );
                              print(
                                  "❌ User didn't connect or connection failed.");
                            }
                          }
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
                        child: const Text(
                          "Automatic",
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Manual()));
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
                        child: const Text(
                          "Manual",
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
