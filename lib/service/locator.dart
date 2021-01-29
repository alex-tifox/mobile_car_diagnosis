import 'package:get_it/get_it.dart';

import './bluetooth_connection_service.dart';
import './elm_bluetooth_connection_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<BluetoothConnectionService>(
      ElmBluetoothConnectionService());
}
