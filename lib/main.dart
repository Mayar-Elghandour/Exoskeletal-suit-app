import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ For MethodChannel
import 'package:exoskeleton_suit_app/LoadingScreen.dart';
import 'package:exoskeleton_suit_app/bluetooth_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

// ✅ Define a method channel for Python bridge (Chaquopy)
const platform = MethodChannel('mat_channel');

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

// ✅ App lifecycle handler (no changes to BluetoothManager logic)
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      BluetoothManager().disconnect();
    } else if (state == AppLifecycleState.resumed) {
      BluetoothManager().resetConnection();
      await Future.delayed(Duration(milliseconds: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// ✅ Example: Function to call Python from Flutter via Android MethodChannel
Future<void> callPythonProcessing(String matFilePath) async {
  try {
    final result = await platform.invokeMethod('processMat', {'path': matFilePath});
    print('📊 Python processing result: $result');
    // You can now use the result in your UI
  } catch (e) {
    print('❌ Failed to call Python processing: $e');
  }
}
