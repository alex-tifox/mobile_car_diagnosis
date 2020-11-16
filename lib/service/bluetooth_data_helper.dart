import 'dart:convert';
import 'dart:typed_data';

import '../model/bluetooth_response.dart';

class BluetoothDataHelper {
  static Uint8List transformCommandToSendReadyFormat(String command) {
    command = command.trim();
    Uint8List hexArray = Uint8List.fromList([
      ...command.split(' ').map((e) => int.parse(e, radix: 16)).toList(),
      ...utf8.encode('\r'),
    ]);

    return hexArray;
  }

  static BluetoothResponse transformRawDataToResponse(Uint8List data) {
    return BluetoothResponse();
  }
}
