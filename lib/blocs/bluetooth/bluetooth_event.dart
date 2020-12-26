part of 'bluetooth_bloc.dart';

@immutable
abstract class BluetoothEvent {}

class BluetoothRequestPairedDevicesEvent extends BluetoothEvent {}

class BluetoothReceivedPairedDevicesEvent extends BluetoothEvent {
  final List<BluetoothDevice> pairedDevices;

  BluetoothReceivedPairedDevicesEvent({
    @required this.pairedDevices,
  });
}

class BluetoothConnectToDeviceEvent extends BluetoothEvent {
  final BluetoothDevice device;

  BluetoothConnectToDeviceEvent({
    @required this.device,
  });
}

class BluetoothDeviceConnectedEvent extends BluetoothEvent {}
