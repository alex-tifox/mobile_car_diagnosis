import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

import './bluetooth_connection_service.dart';
import './main_service.dart';
import './receive_data_handler.dart';
import '../commands/command.dart';
import '../commands/elm_command.dart';

class ElmBluetoothConnectionService implements BluetoothConnectionService {
  /// Represents bluetooth connection to the device
  BluetoothConnection _connection;

  /// Shows bluetooth state of a physical device (smartphone)
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  /// Instance of a [FlutterBluetoothSerial] which implements bridge between
  /// application and native implemented BT workflow
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  /// Current device you are connected to
  BluetoothDevice _device;

  /// Getting all paired devices to the phone
  @override
  Future<List<BluetoothDevice>> get pairedDevicesList async =>
      await _getPairedDevices();
  final Logger _logger = Logger();

  @override
  BluetoothDevice get currentDevice => _device;

  @override
  bool get isDisconnected => _connection == null ? true : false;

  @override
  void dispose() {
    _connection.dispose();
    _connection.close();
    _logger.d('BluetoothConnectionService disposed');
  }

  @override
  Future<void> connectToDevice(BluetoothDevice device) async {
    await _enableBluetooth();

    var connection = await BluetoothConnection.toAddress(device.address);

    _connection = connection;
    _device = device;
    // Setting listener of data coming from connection
    _connection.input
        .listen(ReceiveDataHandler.instance.handleReceiveData)
        .onDone(() {
      MainService().handleDeviceDisconnected();
    });
    await _initialDeviceConfiguration();
    MainService().handleDeviceConnected(_device);
  }

  @override
  Future<void> disconnectFromDevice() async {
    await _connection.close();
    _device = null;
  }

  /// Method helps to send data - [Command] via [_connection] to the
  /// device user is connected to
  @override
  Future<void> sendData(Command command) async =>
      _sendRawData(command.getDataToSend());

  Future<void> _sendRawData(Uint8List rawData) async {
    await _enableBluetooth();
    _connection.output.add(rawData);
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
    var devices = <BluetoothDevice>[];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      _logger.e('Error while getting paired devices. :' + e.toString());
    }

    return devices;
  }

  Future<void> _initialDeviceConfiguration() async {
    for (var data in ElmCommand.getInitialConfigurationCommands()) {
      await _sendRawData(data);
      await Future.delayed(Duration(milliseconds: 400));
    }
  }
}
