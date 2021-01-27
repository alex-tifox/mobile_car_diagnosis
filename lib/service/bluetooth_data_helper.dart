import 'dart:convert';
import 'dart:typed_data';

import '../model/bluetooth_response.dart';

class BluetoothDataHelper {
  static Uint8List transformCommandToSendReadyFormat(String command) {
    command = command.trim();
    var hexArray = Uint8List.fromList([
      ...utf8.encode(command + '\r'),
    ]);

    return hexArray;
  }

  static BluetoothResponse transformRawDataToResponse(Uint8List data) {
    return BluetoothResponse();
  }
}
