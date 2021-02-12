import 'dart:typed_data';

import 'package:flutter/material.dart';

import './command.dart';
import '../helpers/bluetooth_data_helper.dart';

/// Base of any OBD command sent via bluetooth
class ObdCommand implements Command {
  static const String getAllDtcs = '03';
  final String _command;
  ObdCommand({@required String command}) : _command = command;

  @override
  Uint8List getDataToSend() =>
      BluetoothDataHelper.transformCommandToSendReadyFormat(_command);
}
