import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../service/bluetooth_data_helper.dart';

/// Base of any command sent via bluetooth
abstract class Command {
  Uint8List _rawDataForSending;

  Command({
    @required String command,
  }) {
    _rawDataForSending =
        BluetoothDataHelper.transformCommandToSendReadyFormat(command);
  }

  /// This getter is mandatory if you want to sent data to bluetooth connection
  ///
  /// This getter is responsible for data which is stored in Uint8List format
  /// which is required by [BluetoothConnection]
  Uint8List get dataToSend => _rawDataForSending;
}
