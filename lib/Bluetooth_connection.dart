import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetooth_manager.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  List<BluetoothDevice> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBondedDevices();
  }

  Future<void> _fetchBondedDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _devices = devices;
      _isLoading = false;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    await BluetoothManager().connect(device);
    Navigator.pop(context); // Close device list after connecting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98C5EE),
      appBar: AppBar(
        title: const Text('Select Device'),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xff98c5ee)),
        titleTextStyle: const TextStyle(
          color: Color(0xff98c5ee),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 120), // Space from AppBar
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _devices.length,
                separatorBuilder: (context, index) => const Column(
                  children: [
                    SizedBox(height: 10),
                    Divider(color: Colors.white, thickness: 1),
                    SizedBox(height: 10),
                  ],
                ),
                itemBuilder: (context, index) {
                  BluetoothDevice device = _devices[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      title: Text(
                        device.name ?? 'Unknown Device',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        device.address,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.bluetooth_connected),
                      iconColor: const Color(0xFF98C5EE),
                      onTap: (){
                        _connectToDevice(device);
                        Navigator.pop(context);
                      }
                    ),
                  );
                },
              ),
      ),
    );
  }
}
