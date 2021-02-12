import 'package:get_it/get_it.dart';
import 'package:mobile_car_diagnosis/repository/diagnosis_data_repository.dart';
import 'file:///D:/University/Diploma/mobile_car_diagnosis/lib/helpers/receive_data_handler.dart';

import 'bluetooth/bluetooth_connection_service.dart';
import 'bluetooth/elm_bluetooth_connection_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<BluetoothConnectionService>(
      ElmBluetoothConnectionService());
  locator.registerSingleton<DiagnosisDataRepository>(DiagnosisDataRepository());
  locator.registerSingleton<ReceiveDataHandler>(ReceiveDataHandler());
}
