import './obd_command.dart';

enum ElmCommands {
  defaultConfiguration,
  resetConfiguration,
  setProtocol,
}

class ElmCommand extends ObdCommand {
  ElmCommand(String command) : super(command);
}
