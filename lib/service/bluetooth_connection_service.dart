import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

import '../model/bluetooth_request.dart';
import '../model/bluetooth_response.dart';
import '../service/bluetooth_data_helper.dart';

class BluetoothConnectionService {
  static final BluetoothConnectionService _instance =
      BluetoothConnectionService._internal();

  factory BluetoothConnectionService() {
    return _instance;
  }

  BluetoothConnectionService._internal() {
    _connectionToServiceStreamController =
        StreamController<BluetoothResponse>();
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

  /// Getting all paired devices to the phone
  Future<List<BluetoothDevice>> get pairedDevicesList async =>
      await _getPairedDevices();
  Logger _logger = Logger();

  /// Stream controller intended for one-way 'out' communication between
  /// [BluetoothConnectionService] and any other service, which can connect to
  /// this service
  StreamController<BluetoothResponse> _connectionToServiceStreamController;

  /// Stream sink designed for sending responses need to be handled for any
  /// service connected to this [BluetoothConnectionService]
  StreamSink<BluetoothResponse> _connectionToServiceStreamIn;

  /// This stream purpose is to expose ability of listening responses from
  /// [_connectionToServiceStreamController] in [BluetoothConnectionService]
  Stream<BluetoothResponse> connectionToServiceStreamOut;

  void connectToDevice(BluetoothDevice device) async {
    await BluetoothConnection.toAddress(_device.address)
        .then((BluetoothConnection connection) {
      _connection = connection;
      _device = device;
      // Setting listener of data coming from connection
      _connection.input.listen(_receiveData);
    }).catchError((error) {
      _logger.e('Cannot connect!');
      _logger.e(error);
    });
  }

  void disconnectFromDevice() async {
    await _connection.close();
    _device = null;
  }

  void enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  /// Method helps to send data - [BluetoothRequest] via [_connection] to the
  /// device user is connected to
  void sendData(BluetoothRequest command) {
    _connection.output.add(command.getDataToSend);
  }

  /// Listener function designed to handle data came from [_connection]
  void _receiveData(Uint8List data) {
    _connectionToServiceStreamIn.add(
      BluetoothDataHelper.transformRawDataToResponse(data),
    );
  }

  Future<List<BluetoothDevice>> _getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      _logger.e("Error while getting paired devices. :" + e.toString());
    }

    return devices;
  }
}
