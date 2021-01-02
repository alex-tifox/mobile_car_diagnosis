import 'package:flutter/material.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as flutter_bluetooth;

import './device_list_tile_widget.dart';

/// Enables displaying the list of paired devices and manipulations with
/// these devices, e.g. connection to device
class PairedDevicesListWidget extends StatefulWidget {
  final List<flutter_bluetooth.BluetoothDevice> pairedDevicesList;

  PairedDevicesListWidget({
    @required this.pairedDevicesList,
  });

  @override
  _PairedDevicesListWidgetState createState() =>
      _PairedDevicesListWidgetState();
}

class _PairedDevicesListWidgetState extends State<PairedDevicesListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        ...widget.pairedDevicesList
            .map((flutter_bluetooth.BluetoothDevice device) =>
                DeviceListTileWidget(device: device))
            .toList(),
      ],
    );
  }
}
