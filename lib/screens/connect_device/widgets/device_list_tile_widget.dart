import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../../widgets/custom_elevated_button.dart';
import '../../../blocs/blocs.dart';

class DeviceListTileWidget extends StatelessWidget {
  final BluetoothDevice _device;

  DeviceListTileWidget({
    @required BluetoothDevice device,
  }) : _device = device;

  void _connectDevice(BuildContext context) {
    BlocProvider.of<BluetoothBloc>(context)
        .add(BluetoothConnectToDeviceEvent(device: _device));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: ListTile(
        title: Text(
          _device.name,
          style: Theme.of(context).primaryTextTheme.subtitle1,
        ),
        trailing: CustomElevatedButton(
          onPressed: _connectDevice,
          buttonText: 'Connect',
        ),
      ),
    );
  }
}
