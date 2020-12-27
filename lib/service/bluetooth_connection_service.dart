import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

import '../commands/command.dart';
import '../service/receive_data_handler.dart';

class BluetoothConnectionService {
  static final BluetoothConnectionService _instance =
      BluetoothConnectionService._internal();

  factory BluetoothConnectionService() {
    return _instance;
  }

  BluetoothConnectionService._internal();

  /// Represents bluetooth connection to the device
  BluetoothConnection _connection;

  /// Shows bluetooth state of a physical device (smartphone)
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  /// Instance of a [FlutterBluetoothSerial] which implements bridge between
  /// application and native implemented BT workflow
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  /// Current device you are connected to
  BluetoothDevice _device;

  /// Getting all paired devices to the phone
  Future<List<BluetoothDevice>> get pairedDevicesList async =>
      await _getPairedDevices();
  Logger _logger = Logger();

  BluetoothDevice get currentDevice => _device;

  void connectToDevice(BluetoothDevice device) async {
    _enableBluetooth();
    await BluetoothConnection.toAddress(_device.address)
        .then((BluetoothConnection connection) {
      _connection = connection;
      _device = device;
      // Setting listener of data coming from connection
      _connection.input.listen(ReceiveDataHandler().handleReceiveData);
    }).catchError((error) {
      _logger.e('Cannot connect!');
      _logger.e(error);
    });
  }

  void disconnectFromDevice() async {
    await _connection.close();
    _device = null;
  }

  /// Method helps to send data - [Command] via [_connection] to the
  /// device user is connected to
  void sendData(Command command) {
    _enableBluetooth();
    _connection.output.add(command.dataToSend);
  }

  void _enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  Future<List<BluetoothDevice>> _getPairedDevices() async {
    _enableBluetooth();
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      _logger.e("Error while getting paired devices. :" + e.toString());
    }

    return devices;
  }
}
