part of 'bluetooth_bloc.dart';

@immutable
abstract class BluetoothState {}

class BluetoothInitial extends BluetoothState {}

class BluetoothPairedDevicesListState extends BluetoothState {
  final List<BluetoothDevice> pairedDevicesList;

  BluetoothPairedDevicesListState({
    @required this.pairedDevicesList,
  });
}

class BluetoothConnectDeviceInProcess extends BluetoothState {
  final bool connected;

  BluetoothConnectDeviceInProcess({
    this.connected = false,
  });
}
