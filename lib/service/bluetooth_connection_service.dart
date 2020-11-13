import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothConnectionService {
  static final BluetoothConnectionService _instance =
      BluetoothConnectionService._internal();

  factory BluetoothConnectionService() {
    return _instance;
  }

  BluetoothConnectionService._internal() {
    _bluetoothStreamController = StreamController();
  }

  FlutterBlue _flutterBlue = FlutterBlue.instance;

  StreamController _bluetoothStreamController;

  void startScanning() {
    _flutterBlue.startScan(timeout: Duration(seconds: 4));

    var subscription = _flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

    _flutterBlue.stopScan();

    subscription.cancel();
  }
}
