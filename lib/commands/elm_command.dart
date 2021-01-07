import 'dart:convert';
import 'dart:typed_data';

import '../commands/command.dart';

enum ElmCommands { reset, echo, spaces, protocol, lines }

enum ElmOptionState { ON, OFF, AUTO }

class ElmCommand extends Command {
  static const String _atCommand = 'AT';
  final ElmCommands elmCommand;
  final ElmOptionState optionState;
  final bool isInitialConfiguration;

  ElmCommand({
    this.elmCommand,
    this.optionState,
    this.isInitialConfiguration,
  }) : assert(
            (elmCommand != null && optionState != null) ||
                (elmCommand == null &&
                    optionState == null &&
                    isInitialConfiguration != null),
            'If you want to make initial configuration using one command - '
            'provide only required isInitialConfiguration, otherwise '
            'provide both command and option state');

  static const Map<ElmCommands, Map<ElmOptionState, String>>
      _availableElmCommands = {
    ElmCommands.reset: {
      ElmOptionState.AUTO: 'Z',
    },
    ElmCommands.echo: {
      ElmOptionState.ON: 'E1',
      ElmOptionState.OFF: 'E0',
      ElmOptionState.AUTO: 'E0',
    },
    ElmCommands.spaces: {
      ElmOptionState.ON: 'S1',
      ElmOptionState.OFF: 'S0',
      ElmOptionState.AUTO: 'S0',
    },
    ElmCommands.protocol: {
      ElmOptionState.AUTO: 'SP 0',
    },
    ElmCommands.lines: {
      ElmOptionState.ON: 'L1',
      ElmOptionState.OFF: 'L0',
      ElmOptionState.AUTO: 'L0',
    },
  };

  @override
  Uint8List _constructDataToSend() => utf8.encode(_atCommand +
      ElmCommand._availableElmCommands[this.elmCommand][this.optionState]);

  @override
  Uint8List getDataToSend() {
    // TODO: implement getDataToSend
    throw UnimplementedError();
  }
}
