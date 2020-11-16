import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

class BluetoothConnectionService {
  static final BluetoothConnectionService _instance =
      BluetoothConnectionService._internal();

  factory BluetoothConnectionService() {
    return _instance;
  }

  BluetoothConnectionService._internal() {
    _serviceToConnectionStreamController = StreamController();
    _serviceToConnectionStreamOut = _serviceToConnectionStreamController.stream;
    serviceToConnectionStreamIn = _serviceToConnectionStreamController.sink;

    _connectionToServiceStreamController = StreamController();
    _connectionToServiceStreamIn = _connectionToServiceStreamController.sink;
    connectionToServiceStreamOut = _connectionToServiceStreamController.stream;
  }

  /// Represents bluetooth connection to the device
  BluetoothConnection _connection;

  /// Shows bluetooth state of a physical device (smartphone)
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  /// Instance of a [FlutterBluetoothSerial] which implements bridge between
  /// application and native implemented BT workflow
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  /// Current device you are connected to
  BluetoothDevice _device;
  Logger _logger = Logger();

  /// Stream controller intended for one-way 'in' communication between any service and
  /// this [BluetoothConnectionService] via service facts i.e. data requests
  StreamController _serviceToConnectionStreamController;

  /// StreamSink designed for exposing ability of sending requests to the
  /// bluetooth connection service
  StreamSink serviceToConnectionStreamIn;

  /// This stream purpose is to listen for requests came outside
  /// [BluetoothConnectionService] service
  Stream _serviceToConnectionStreamOut;

  /// Stream controller intended for one-way 'out' communication between
  /// [BluetoothConnectionService] and any other service, which can connect to
  /// this service
  StreamController _connectionToServiceStreamController;

  /// Stream sink designed for sending responses need to be handled for any
  /// service connected to this [BluetoothConnectionService]
  StreamSink _connectionToServiceStreamIn;

  /// This stream purpose is to expose ability of listening responses from
  /// [_connectionToServiceStreamController] in [BluetoothConnectionService]
  Stream connectionToServiceStreamOut;

  /// When user choose a device he wants to connect this method stores the
  /// device instance user is connected to
  void setBluetoothDevice() {}

  void connectToDevice() {}
  void disconnectFromDevice() {}

  void enableBluetooth() {}

  void getPairedDevices() {}

  /// Method helps to send data to the device via [_connection] user
  /// is connected to
  void sendData() {}

  /// Listener function designed to handle data came from [_connection]
  void receiveData() {}
}
