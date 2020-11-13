part of 'bluetooth_bloc.dart';

@immutable
abstract class BluetoothEvent {}

class BluetoothRequestDataEvent extends BluetoothEvent {}

class BluetoothStartScanEvent extends BluetoothEvent {}
