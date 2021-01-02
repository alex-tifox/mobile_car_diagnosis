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

class BluetoothDeviceConnectedEvent extends BluetoothEvent {
  final BluetoothDevice device;

  BluetoothDeviceConnectedEvent({
    @required this.device,
  });
}

class BluetoothDeviceDisconnectEvent extends BluetoothEvent {}

class BluetoothDeviceDisconnectedEvent extends BluetoothEvent {}
