import 'package:get_it/get_it.dart';
import 'package:mobile_car_diagnosis/service/main_service.dart';

import './bluetooth/bluetooth_connection_service.dart';
import './bluetooth/elm_bluetooth_connection_service.dart';
import '../helpers/receive_data_handler.dart';
import '../repository/diagnosis_data_repository.dart';
import '../service/bluetooth/mock_bluetooth_connectoin_service.dart';

final locator = GetIt.instance;

void setupLocator({bool isDemo = false}) {
  locator.registerSingleton<ReceiveDataHandler>(ReceiveDataHandler());
  if (isDemo) {
    locator.registerSingleton<BluetoothConnectionService>(
        MockBluetoothConnectionService());
  } else {
    locator.registerSingleton<BluetoothConnectionService>(
        ElmBluetoothConnectionService());
  }

  locator.registerSingleton<DiagnosisDataRepository>(DiagnosisDataRepository());
  locator.registerSingleton<MainService>(MainService());
}
