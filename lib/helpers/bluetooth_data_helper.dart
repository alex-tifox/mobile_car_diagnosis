import 'dart:convert';
import 'dart:typed_data';

class BluetoothDataHelper {
  static Uint8List transformCommandToSendReadyFormat(String command) {
    command = command.trim();

    return Uint8List.fromList([
      ...utf8.encode(command + '\r'),
    ]);
  }
}
