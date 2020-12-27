import 'package:mobile_car_diagnosis/model/diagnosis_data_model.dart';
import 'package:mobile_car_diagnosis/model/dtc_code.dart';

class DiagnosisDataRepository {
  static final DiagnosisDataRepository _instance =
      DiagnosisDataRepository._internal();

  factory DiagnosisDataRepository() {
    return _instance;
  }

  DiagnosisDataRepository._internal();

  final List<DtcCode> _dtcCodes = List();

  void addDtcCode(DtcCode dtcCode) {
    _dtcCodes.add(dtcCode);
  }

  List<DtcCode> get allDtcCodes => _dtcCodes;
}
