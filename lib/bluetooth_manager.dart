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
  Future<void> sendData(String data) async {
    if (isConnected) {
      _connection!.output.add(utf8.encode(data + "\r\n"));
      await _connection!.output.allSent; // wait for data to be sent
    }
  }

  /// Handles incoming data from the connected device.
  ///
  /// The data is converted to a string using UTF-8 encoding and
  /// printed to the console. The actual processing of the received
  /// data should be implemented in subclasses.
  ///
  /// [data] is the received data as a [Uint8List].
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
