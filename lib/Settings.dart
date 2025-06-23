import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:exoskeleton_suit_app/Bluetooth_connection.dart';
import 'package:exoskeleton_suit_app/Language.dart';
import 'package:exoskeleton_suit_app/Themes.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98C5EE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff98c5ee)),
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const BasicModes()),);
          },
        ),
        title: const Text('Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        child: ListView(
          children: [
            _buildRoundedTile(
              icon: Icons.bluetooth,
              title: "Bluetooth connection",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BluetoothPage()));
              },
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white),
            const SizedBox(height: 20),
            _buildRoundedTile(
              icon: Icons.color_lens,
              title: "Themes",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ThemePage()));
              },
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white),
            const SizedBox(height: 20),
            _buildRoundedTile(
              icon: Icons.language,
              title: "Languages",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Language()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // 👈 Rounded corners here
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 19)),
        minVerticalPadding: 20,
        leading: Icon(icon, color: const Color(0xFF98C5EE)),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: onTap,
      ),
    );
  }
}
