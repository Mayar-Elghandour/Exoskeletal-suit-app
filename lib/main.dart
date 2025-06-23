import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/LoadingScreen.dart';
import 'package:exoskeleton_suit_app/bluetooth_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensures proper binding before runApp
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exoskeleton Suit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppLifecycleHandler(child: LoadingScreen()),
    );
  }
}

// ✅ Add this mixin to handle lifecycle cleanup
class AppLifecycleHandler extends StatefulWidget {
  final Widget child;

  const AppLifecycleHandler({super.key, required this.child});

  @override
  State<AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends State<AppLifecycleHandler>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BluetoothManager().resetConnection();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✅ Handle app lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      BluetoothManager().disconnect();
    } else if (state == AppLifecycleState.resumed) {
      BluetoothManager().resetConnection(); // optional: refresh clean state
      await Future.delayed(Duration(milliseconds: 1000));

    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
