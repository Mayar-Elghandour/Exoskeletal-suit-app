import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Bluetooth_connection.dart';
import 'package:exoskeleton_suit_app/Manual.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
import 'package:exoskeleton_suit_app/xml_processing_automatic.dart';
import 'package:exoskeleton_suit_app/eye_did.dart';
import 'package:exoskeleton_suit_app/gaze_cursor_overlay.dart';
import 'generated/app_localizations.dart';
import 'package:flutter/rendering.dart';

class Advanced extends StatefulWidget {
  const Advanced({Key? key}) : super(key: key);

  @override
  State<Advanced> createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                // Left Circle
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xff98C5EE),
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

                // Back Button (MetaData + Tap)
                Positioned(
                  top: 10,
                  left: 5,
                  child: MetaData(
                    metaData: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const BasicModes()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 50, color: Colors.white),
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
                ),

                // Right Circle
                Positioned(
                  top: -50,
                  left: screenWidth - 75,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xff98C5EE),
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

                // Home Button (MetaData + Tap)
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
                    child: IconButton(
                      icon: const Icon(Icons.home_outlined, size: 50, color: Colors.white),
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
                ),

                // Title
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.advanced_modes,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Federant',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Main Buttons
                Positioned(
                  top: 280,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                    decoration: BoxDecoration(
                      color: const Color(0xff98C5EE),
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
                    child: Column(
                      children: [
                        // 👁️ Gaze-activated AUTOMATIC button
                        MetaData(
                          metaData: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            if (BluetoothManager().isConnected) {
                              await BluetoothManager().sendData("hi you are on the automatic mode", context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const Automatic()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.automatic_mode_activated)),
                              );
                              return;
                            }

                            final shouldConnect = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!.bluetooth_not_connected),
                                content: Text(AppLocalizations.of(context)!
                                    .please_connect_to_a_Bluetooth_device_before_sending_data),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text(AppLocalizations.of(context)!.go_to_bluetooth_page),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text(AppLocalizations.of(context)!.cancel),
                                  ),
                                ],
                              ),
                            );

                            if (shouldConnect == true) {
                              final connected = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(builder: (_) => BluetoothPage()),
                              );

                              if (connected == true && BluetoothManager().isConnected) {
                                await BluetoothManager().sendData("hi you are on the automatic mode", context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const Automatic()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.automatic_mode_activated)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!
                                      .still_not_connected_to_a_device)),
                                );
                              }
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Future.delayed(const Duration(milliseconds: 200));
                              if (BluetoothManager().isConnected) {
                                await BluetoothManager().sendData("hi you are on the automatic mode", context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const Automatic()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppLocalizations.of(context)!.automatic_mode_activated)),
                                );
                                return;
                              }
                              // same connection check and fallback dialog code here if needed
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 4,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.automatic,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Federant',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // 👁️ Gaze-activated MANUAL button
                        MetaData(
                          metaData: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Manual()),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const Manual()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 4,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.manual,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Federant',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const GazeCursorOverlay(), // 👁️ Gaze feedback
      ],
    );
  }
}
