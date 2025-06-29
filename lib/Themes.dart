import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'generated/app_localizations.dart';

// ThemeNotifier to manage theme changes
class ThemeNotifier extends ChangeNotifier {
  bool isDarkTheme = false; // Default theme is light

  // Function to toggle between dark and light theme
  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners(); // Notify listeners of the change
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),  // Provide ThemeNotifier here
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Theme App',
      theme: ThemeData.light(),  // Light theme
      darkTheme: ThemeData.dark(),  // Dark theme
      themeMode: Provider.of<ThemeNotifier>(context).isDarkTheme
          ? ThemeMode.dark
          : ThemeMode.light,  // Toggle theme based on ThemeNotifier
      home: ThemePage(),  // Theme selection page
    );
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Choose Theme"),
        backgroundColor: Colors.blue[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BasicModes()),
  );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text(
                "Preview Themes",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60),
          
              // High Contrast Theme Preview
              GestureDetector(
                onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('low contrast mode activated!')),
                            );
                },
                child: Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.light_mode, size: 50, color: Colors.orange),
                      SizedBox(height: 10),
                      Text("Low Contrast",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
          
              // Low Contrast Theme Preview
              GestureDetector(
                onTap: () {
                  // Toggle theme to light
                  //int background_Color = 0xff98C5EE; // Set background color to black
                  ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('high contrast mode activated!')),
                            );
                },
                child: Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.dark_mode, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text("High Contrast",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
