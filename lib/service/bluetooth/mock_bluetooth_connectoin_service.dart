import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

import './bluetooth_connection_service.dart';
import '../../commands/command.dart';
import '../../helpers/receive_data_handler.dart';
import '../locator.dart';
import '../main_service.dart';

class MockBluetoothConnectionService implements BluetoothConnectionService {
  MockBluetoothConnectionService() {
    _receiveDataHandler = locator.get<ReceiveDataHandler>();
    _mockedConnection = StreamController<Uint8List>();
  }

  /// Represents bluetooth connection to the device
  BluetoothConnection _connection;

  ReceiveDataHandler _receiveDataHandler;

  /// Shows bluetooth state of a physical device (smartphone)
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  /// Instance of a [FlutterBluetoothSerial] which implements bridge between
  /// application and native implemented BT workflow
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  /// Current device you are connected to
  BluetoothDevice _device;

  StreamController<Uint8List> _mockedConnection;

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
    _mockedConnection.close();
    _logger.d('BluetoothConnectionService disposed');
  }

  @override
  Future<void> connectToDevice(BluetoothDevice device) async {
    await _enableBluetooth();

    _device = device;
    // Setting listener of data coming from connection
    _mockedConnection.stream
        .listen(_receiveDataHandler.handleReceiveData)
        .onDone(() {
      MainService().handleDeviceDisconnected();
    });
    await _initialDeviceConfiguration();
    await Future.delayed(Duration(seconds: 3));
    locator.get<MainService>().handleDeviceConnected(_device);
  }

  @override
  Future<void> disconnectFromDevice() async {
    await _mockedConnection.close();
    _device = null;
  }

  /// Method helps to send data - [Command] via [_connection] to the
  /// device user is connected to
  @override
  Future<void> sendData(Command command) async =>
      _sendRawData(command.getDataToSend());

  Future<void> _sendRawData(Uint8List rawData) async {
    await _enableBluetooth();

    if (utf8.decode(rawData) == '03\r') {
      _mockedConnection.sink.add(Uint8List.fromList(
          [52, 51, 49, 49, 51, 51, 70, 68, 49, 50, 48, 48, 48, 48]));
      _mockedConnection.sink.add(Uint8List.fromList([0x3e, 0x0D]));
    }
  }

  Future<void> _enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  Future<List<BluetoothDevice>> _getPairedDevices() async {
    await _enableBluetooth();
    return <BluetoothDevice>[
      BluetoothDevice(name: 'Demo car 1', address: '22:e5:12:6f:ad:1d:0c'),
      BluetoothDevice(name: 'Demo car 2', address: '11:e9:12:9f:8d:8c:5a'),
      BluetoothDevice(name: 'Demo car 3', address: '65:e5:78:a9:e1:5d:9c'),
    ];
  }

  Future<void> _initialDeviceConfiguration() async {
    await Future.delayed(Duration(milliseconds: 400));
  }
}
