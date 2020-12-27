import 'package:flutter/material.dart';

import './command.dart';

/// Base of any OBD command sent via bluetooth
class ObdCommand extends Command {
  static const String getAllDtcs = '03';
  ObdCommand({@required String command}) : super(command: command);
}
