import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../commands/command.dart';

abstract class BluetoothConnectionService {
  /// Getting all paired devices to the phone
  Future<List<BluetoothDevice>> get pairedDevicesList;

  BluetoothDevice get currentDevice;

  bool get isDisconnected;

  void dispose();

  Future<void> connectToDevice(BluetoothDevice device);

  Future<void> disconnectFromDevice();

  Future<void> sendData(Command command);
}
