import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../service/stream_facts/duplex_stream_fact.dart';

enum BluetoothRequestName { paired_devices, connect_device, disconnect_device }

enum BluetoothResponseName {
  paired_devices,
  device_connected,
  device_disconnected
}

class BluetoothRequest extends RequestStreamFact {
  final BluetoothRequestName requestName;

  /// Required when you want to connect or disconnect a device
  BluetoothDevice device;

  BluetoothRequest({
    @required this.requestName,
    this.device,
  }) :

        /// Constructor assertions required to guarantee flow of required
        /// data in [BluetoothRequest] to avoid some data missed, null pointer
        /// exceptions etc for every single request
        assert((requestName == BluetoothRequestName.paired_devices) ||
            (requestName == BluetoothRequestName.connect_device &&
                device != null) ||
            (requestName == BluetoothRequestName.disconnect_device));
}

class BluetoothResponse extends ResponseStreamFact {
  final BluetoothResponseName responseName;

  /// Returned reference of device you are connected to
  BluetoothDevice device;

  /// List of paired devices you can connect to
  List<BluetoothDevice> pairedDevices;

  BluetoothResponse({
    @required this.responseName,
    this.device,
    this.pairedDevices,
  }) :

        /// Constructor assertions required to guarantee flow of required
        /// data in [BluetoothResponse] to avoid some data missed, null pointer
        /// exceptions etc for every single response
        assert((responseName == BluetoothResponseName.paired_devices) ||
            (responseName == BluetoothResponseName.device_connected &&
                device != null) ||
            (responseName == BluetoothResponseName.device_disconnected));
}
