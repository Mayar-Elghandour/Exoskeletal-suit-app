// bluetooth_manager.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothManager {
  // Singleton instance
  static final BluetoothManager _instance = BluetoothManager._internal();

  factory BluetoothManager() => _instance;

  BluetoothManager._internal();

  BluetoothConnection? _connection;
  bool get isConnected => _connection != null && _connection!.isConnected;

  // Connect to a device
  Future<void> connect(BluetoothDevice device) async {
    if (_connection != null && _connection!.isConnected) {
      return;
    }
    _connection = await BluetoothConnection.toAddress(device.address);
    _connection!.input?.listen(_onDataReceived).onDone(() {
      _connection = null;
    });
  }

  // Send data to the connected device
  void sendData(String data) {
    if (isConnected) {
      _connection!.output.add(utf8.encode(data + "\r\n"));
    }
  }

  // Handle incoming data
  void _onDataReceived(Uint8List data) {
    String receivedData = utf8.decode(data);
    // Process received data
    print('Received: $receivedData');
  }

  // Disconnect from the device
  void disconnect() {
    _connection?.dispose();
    _connection = null;
  }
}
