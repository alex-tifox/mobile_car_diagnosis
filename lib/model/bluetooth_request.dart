import 'dart:typed_data';

import '../commands/command.dart';
import '../service/bluetooth_connection_service.dart';

enum RequestDescription {
  speed,
  available_pids,
  break_system,
  rpm,
}

/// Represents a request made to [BluetoothConnectionService]
class BluetoothRequest {
  final Command _command;

  BluetoothRequest(this._command);

  Uint8List get getDataToSend => _command.dataToSend;
}
