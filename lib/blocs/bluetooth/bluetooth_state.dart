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

class BluetoothConnectDeviceInProcessState extends BluetoothState {
  final bool connected;
  final BluetoothDevice device;

  BluetoothConnectDeviceInProcessState({
    this.connected = false,
    this.device,
  });
}

class BluetoothDeviceDisconnectedState extends BluetoothState {}
