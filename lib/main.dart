import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:exoskeleton_suit_app/LoadingScreen.dart';
import 'package:exoskeleton_suit_app/bluetooth_managerrr2.dart';
//import 'package:exoskeleton_suit_app/bluetooth_manager.dart';
import 'generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:exoskeleton_suit_app/locale_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

// ✅ Define a method channel for Python bridge (Chaquopy)
const platform = MethodChannel('mat_channel');

class MainApp extends StatefulWidget {
  const MainApp({super.key});
 
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;
  
final ThemeData myLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
);

final ThemeData myDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  primaryColor: Colors.deepPurple,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  void initState(){
    super.initState();
    BluetoothManager().autoConnectIfPossible();
    LocaleController().setLocaleCallback = setLocale;
  }
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Exoskeleton Suit App',
      debugShowCheckedModeBanner: false,
      theme:myLightTheme,
      darkTheme: myDarkTheme,
      themeMode: ThemeMode.system,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
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
