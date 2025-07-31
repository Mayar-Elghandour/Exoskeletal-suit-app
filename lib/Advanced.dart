import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Bluetooth_connection.dart';
import 'package:exoskeleton_suit_app/Manual.dart';
import 'xml_processing_automatic.dart';
import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
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
  late OverlayEntry _gazeOverlay;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertGazeOverlay();
    });

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

  void _insertGazeOverlay() {
    _gazeOverlay = OverlayEntry(
      builder: (_) => const GazeCursorOverlay(),
    );
    Overlay.of(context, rootOverlay: true)?.insert(_gazeOverlay);
  }

  @override
  void dispose() {
    _gazeOverlay.remove();
    super.dispose();
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

  Future<void> _handleAutomaticMode() async {
    print("🔁 Automatic mode triggered");

    await Future.delayed(const Duration(milliseconds: 200));

    if (BluetoothManager().isConnected) {
      try {
        await BluetoothManager().sendData("hi you are on the automatic mode", context);
      } catch (e) {
        print("❌ Bluetooth send failed: $e");
      }

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
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        MetaData(
          metaData: () => Navigator.of(context).pop(true),
          behavior: HitTestBehavior.opaque,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: const BorderSide(color: Colors.blue, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.go_to_bluetooth_page,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        MetaData(
          metaData: () => Navigator.of(context).pop(false),
          behavior: HitTestBehavior.opaque,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: const BorderSide(color: Colors.red, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(fontSize: 18),
            ),
          ),
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
        try {
          await BluetoothManager().sendData("hi you are on the automatic mode", context);
        } catch (e) {
          print("❌ Bluetooth send failed after connect: $e");
        }

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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorations
            Positioned(
              top: -50,
              left: -50,
              child: _buildCircleDecoration(),
            ),
            Positioned(
              top: -50,
              left: screenWidth - 75,
              child: _buildCircleDecoration(),
            ),

            // Back Icon
            Positioned(
              top: 10,
              left: 5,
              child: _buildNavButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BasicModes()),
                ),
              ),
            ),

            // Home Icon
            Positioned(
              top: 5,
              left: screenWidth - 55,
              child: _buildNavButton(
                icon: Icons.home_outlined,
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BasicModes()),
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
                    color: Color.fromARGB(255, 72, 71, 71),
                  ),
                ),
              ),
            ),

            // Buttons
            Positioned(
              top: 280,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildModeButtons(screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleDecoration() {
    return Container(
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
    );
  }

  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return MetaData(
      metaData: onTap,
      behavior: HitTestBehavior.opaque,
      child: IconButton(
        icon: Icon(icon, size: 50, color: Colors.white),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildModeButtons(double screenWidth) {
    return Container(
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
          MetaData(
            metaData: _handleAutomaticMode,
            behavior: HitTestBehavior.opaque,
            child: ElevatedButton(
              onPressed: _handleAutomaticMode,
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
          MetaData(
            metaData: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Manual()));
            },
            behavior: HitTestBehavior.opaque,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Manual()));
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
    );
  }
}
