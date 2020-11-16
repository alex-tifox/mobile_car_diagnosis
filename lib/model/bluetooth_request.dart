import 'dart:typed_data';

import '../commands/obd_command.dart';
import '../service/bluetooth_connection_service.dart';

enum RequestDescription {
  speed,
}

/// Represents a request made to [BluetoothConnectionService]
class BluetoothRequest {
  final ObdCommand _command;
  final Uint8List _rawHexRequest;
  final RequestDescription _requestDescription;

  BluetoothRequest(
    this._rawHexRequest,
    this._requestDescription,
    this._command,
  );

  Uint8List get getDataToSend => _command.getDataToSend;
}
