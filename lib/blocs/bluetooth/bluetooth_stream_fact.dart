import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../bluetooth/bluetooth_bloc.dart';
import '../../service/stream_facts/duplex_stream_fact.dart';

class BluetoothPairedDevicesRequest extends RequestStreamFact {}

class BluetoothPairedDevicesResponse extends ResponseStreamFact {
  final BluetoothReceivedPairedDevicesEvent bluetoothReceivedPairedDevicesEvent;

  BluetoothPairedDevicesResponse({
    @required this.bluetoothReceivedPairedDevicesEvent,
  });
}

class BluetoothConnectToDeviceRequest extends RequestStreamFact {
  final BluetoothDevice device;

  BluetoothConnectToDeviceRequest({
    @required this.device,
  });
}

class BluetoothDeviceConnectedResponse extends ResponseStreamFact {}
