import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'bluetooth_managerrr2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bluetooth_manager.dart';
import 'generated/app_localizations.dart';

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
    BluetoothManager().resetConnection();
    _fetchBondedDevices();
  }

  Future<void> _fetchBondedDevices() async {
    await _requestPermissions();
    //await Future.delayed(const Duration(seconds: 1));

    bool isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
    if (!isEnabled) {
      await FlutterBluetoothSerial.instance.requestEnable();
      //await Future.delayed(const Duration(seconds: 1));
    }

    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    setState(() {
      _devices = devices;
      _isLoading = false;
    });
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses.values.any((status) => status != PermissionStatus.granted)) {
      // Show alert if not granted
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text(AppLocalizations.of(context)!.permission_required),
          content:
               Text(AppLocalizations.of(context)!.bluetooth_and_location_permissions_are_required),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:  Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    //BluetoothManager().disconnect();
    await Future.delayed(const Duration(milliseconds: 1000));
    final success = await BluetoothManager().connect(device);

    setState(() => _isLoading = false);

    if (success) {
      print("🟢 Device connected successfully.");
      Navigator.pop(context, true); // Return success
    } else {
      print("🔴 Device connection failed.");
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.failed_to_connect_to_a_device)),
      );
      Navigator.pop(context, false); // Return failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98C5EE),
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.select_device),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xff98c5ee)),
        titleTextStyle: const TextStyle(
          color: Color(0xff98c5ee),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _isLoading
          ?  Center(child: CircularProgressIndicator())
          : _devices.isEmpty
              ?  Center(child: Text(AppLocalizations.of(context)!.no_bonded_devices_found))
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                  itemCount: _devices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
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
                            horizontal: 20, vertical: 16),
                        title: Text(
                          device.name ?? AppLocalizations.of(context)!.unknown_device,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        subtitle: Text(device.address,
                            style: const TextStyle(fontSize: 14)),
                        trailing: const Icon(Icons.bluetooth_connected,
                            color: Color(0xFF98C5EE)),
                        onTap: () => _connectToDevice(device),
                      ),
                    );
                  },
                ),
    );
  }
}
