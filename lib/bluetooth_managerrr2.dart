import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'Bluetooth_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/app_localizations.dart';

class BluetoothManager {
  // Singleton pattern
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  BluetoothConnection? _connection;
  BluetoothDevice? _lastConnectedDevice;
  Function()? onDisconnected;

  bool get isConnected => _connection != null && _connection!.isConnected;

  /// Expose the last connected device
  BluetoothDevice? get connectedDevice => _lastConnectedDevice;

  void _onDataReceived(Uint8List data) {
    String receivedData = utf8.decode(data);
    print("📥 Received: $receivedData");

  }
  
  Future<void> resetConnection() async {
  try {
    await _connection?.close(); // Proper async closing
    await Future.delayed(const Duration(milliseconds: 500)); // Give system time to release socket
  } catch (e) {
    print("⚠️ Error during dispose: $e");
  }

  _connection = null;
  _lastConnectedDevice = null;

  print("♻️ BluetoothManager fully reset.");
}


  Future<bool> connect(BluetoothDevice device) async {
  // ✅ Check and close any existing connection
  if (_connection != null) {
    try {
      if (_connection!.isConnected) {
        await _connection!.close();
        print("🔒 Closed previous connection.");
      }
    } catch (e) {
      print("⚠️ Error closing previous connection: $e");
    }
    _connection = null;
  }

  try {
    // ✅ Cancel ongoing discovery (required for some Android versions)
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    await Future.delayed(Duration(seconds: 3)); // ⏳ Wait to let the socket clean up

    print("🔌 Attempting connection to ${device.name}");

    // ✅ Now it's safe to connect
    _connection = await BluetoothConnection.toAddress(device.address);
    _lastConnectedDevice = device;
print("🔧 Saving device address: ${device.address}");
await saveDefaultDevice(device.address);
print("✅ Device address saved.");

    print("✅ Connected to ${device.name}");

    // ✅ Set up listener
    _connection!.input?.listen(_onDataReceived).onDone(() async {
      print("⚠️ Connection lost from ${device.name}");
      _connection = null;
      onDisconnected?.call();
    });

    return true;
  } catch (e) {
    print("❌ Connection error: $e");
    _connection = null;
    return false;
  }
}


Future<void> saveDefaultDevice(String address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); 
  await prefs.setString('default_bluetooth_address', address);
  print("💾 Saved default Bluetooth address: $address");
}

Future<String?> getDefaultBluetoothDevice() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('default_bluetooth_address');
}

Future<void> autoConnectIfPossible() async {
  String? address =  await getDefaultBluetoothDevice();
  print("🔑 Default Bluetooth address: $address");
 // ✅ Correct function

  if (address != null) {
    try {
      List<BluetoothDevice> bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();

      BluetoothDevice? device;
      for (var d in bondedDevices) {
        if (d.address == address) {
          device = d;
          break;
        }
      }

      if (device != null) {
        print("🔄 Auto-connecting to ${device.name}");
        await connect(device);
        print("✅ Auto-connection successful.");
      } else {
        print("⚠️ Default device not found among bonded devices.");
      }
    } catch (e) {
      print("❌ Auto-connect failed: $e");
    }
  } else {
    print("ℹ️ No default Bluetooth device set.");
  }
}

  /// Attempt to reconnect up to 3 times
  /* Future<void> _attemptReconnect() async {
    const maxRetries = 3;
    //const delay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      print('🔄 Reconnection attempt $attempt...');
      if (_lastConnectedDevice != null) {
        try {
          _connection = await BluetoothConnection.toAddress(_lastConnectedDevice!.address);
          print('✅ Reconnection successful');

          _connection!.input?.listen(_onDataReceived).onDone(() async {
            print("⚠️ Disconnected again from ${_lastConnectedDevice!.name}");
            _connection = null;
            onDisconnected?.call();
            await _attemptReconnect();
          });
          return;
        } catch (e) {
          print('❌ Reconnection failed: $e');
        }
      }
      //await Future.delayed(delay);
    }

    print('❌ Failed to reconnect after $maxRetries attempts');
  }*/

  /// Public method to check and reconnect if needed
  Future<bool> checkAndReconnect() async {
    if (isConnected) return true;
    print("⚠️ Not connected. Trying to reconnect...");
    //await _attemptReconnect();
    return isConnected;
  }

  /// Send string data over Bluetooth
  Future<void> sendData(String data, BuildContext context) async {
    //await Future.delayed(const Duration(milliseconds: 100));

    if (!isConnected) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text(AppLocalizations.of(context)!.bluetooth_not_connected),
          content:  Text(
              AppLocalizations.of(context)!.please_connect_to_a_Bluetooth_device_before_sending_data),
          actions: [
            TextButton(
              child:  Text(AppLocalizations.of(context)!.go_to_bluetooth_page),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

              // Delay navigation until next frame
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => BluetoothPage()));
                });
              },
            ),
            TextButton(
              child:  Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }
    try {
      _connection!.output.add(utf8.encode(data + "\r\n"));
      await _connection!.output.allSent;
      print("✅ Data sent: $data");
    } catch (e) {
      final local = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text(local.send_failed),
          content: Text("${local.error_sending_data} $e"),
          actions: [
            TextButton(
              child:  Text(local.ok),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  /// Listen to received Bluetooth data

  /// Disconnect the current Bluetooth connection
  void disconnect() {
    _connection?.close();
    _connection = null;
    print("🔌 Disconnected manually");
  }
}
