import 'dart:typed_data';

/// Base of any command sent via bluetooth
abstract class Command {
  /// This getter is mandatory if you want to sent data to bluetooth connection
  ///
  /// This getter is responsible for data which is stored in Uint8List format
  /// which is required by [BluetoothConnection]
  Uint8List getDataToSend();

  Uint8List _constructDataToSend();
}
