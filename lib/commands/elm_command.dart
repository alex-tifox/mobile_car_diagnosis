import 'dart:convert';
import 'dart:typed_data';

import '../commands/command.dart';

enum ElmCommands { reset, echo, spaces, protocol, lines }

enum ElmOptionState { ON, OFF, AUTO }

class ElmCommand implements Command {
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

  ElmCommand._reset(ElmOptionState state)
      : this(elmCommand: ElmCommands.reset, optionState: state);

  ElmCommand._echo(ElmOptionState state)
      : this(elmCommand: ElmCommands.reset, optionState: state);

  ElmCommand._spaces(ElmOptionState state)
      : this(elmCommand: ElmCommands.reset, optionState: state);

  ElmCommand._protocol(ElmOptionState state)
      : this(elmCommand: ElmCommands.reset, optionState: state);

  ElmCommand._lines(ElmOptionState state)
      : this(elmCommand: ElmCommands.reset, optionState: state);

  Uint8List _constructDataToSend() => utf8.encode(_atCommand +
      ElmCommand._availableElmCommands[this.elmCommand][this.optionState]);

  @override
  Uint8List getDataToSend() => _constructDataToSend();

  static List<Uint8List> getInitialConfigurationCommands() => [
        ElmCommand._reset(ElmOptionState.AUTO).getDataToSend(),
        ElmCommand._echo(ElmOptionState.AUTO).getDataToSend(),
        ElmCommand._lines(ElmOptionState.AUTO).getDataToSend(),
        ElmCommand._spaces(ElmOptionState.AUTO).getDataToSend(),
        ElmCommand._protocol(ElmOptionState.AUTO).getDataToSend(),
      ];

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
}
