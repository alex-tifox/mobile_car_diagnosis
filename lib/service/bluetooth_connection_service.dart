import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

import '../commands/command.dart';
import '../service/main_service.dart';
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
  bool get isDisconnected => _connection == null ? true : false;

  void dispose() {
    _connection.dispose();
    _connection.close();
    _logger.d('BluetoothConnectionService disposed');
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await _enableBluetooth();

    BluetoothConnection connection =
        await BluetoothConnection.toAddress(device.address);

    _connection = connection;
    _device = device;
    // Setting listener of data coming from connection
    _connection.input.listen(ReceiveDataHandler().handleReceiveData).onDone(() {
      MainService().handleDeviceDisconnected();
    });
    MainService().handleDeviceConnected(_device);
  }

  Future<void> disconnectFromDevice() async {
    await _connection.close();
    _device = null;
  }

  /// Method helps to send data - [Command] via [_connection] to the
  /// device user is connected to
  Future<void> sendData(Command command) async {
    await _enableBluetooth();
    _connection.output.add(command.dataToSend);
    await _connection.output.allSent;
  }

  Future<void> _enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  Future<List<BluetoothDevice>> _getPairedDevices() async {
    await _enableBluetooth();
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      _logger.e("Error while getting paired devices. :" + e.toString());
    }

    return devices;
  }
}
