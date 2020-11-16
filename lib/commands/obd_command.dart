import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../service/bluetooth_data_helper.dart';

enum ObdCommands {
  speed,
  rpm,
  mil,
}

/// Base of any command sent via bluetooth
class ObdCommand {
  final String _command;
  Uint8List _rawDataForSending;
  ObdCommand(this._command) {
    _rawDataForSending =
        BluetoothDataHelper.transformCommandToSendReadyFormat(_command);
  }

  /// This getter is mandatory if you want to sent data to bluetooth connection
  ///
  /// This getter is responsible for data which is stored in Uint8List format
  /// which is required by [BluetoothConnection]
  Uint8List get getDataToSend => _rawDataForSending;
}
