import '../model/dtc_code.dart';

class DiagnosisDataRepository {
  static final DiagnosisDataRepository _instance =
      DiagnosisDataRepository._internal();

  factory DiagnosisDataRepository() {
    return _instance;
  }

  DiagnosisDataRepository._internal();

  final List<DtcCode> _dtcCodes = [];

  void addDtcCode(DtcCode dtcCode) {
    _dtcCodes.add(dtcCode);
  }

  List<DtcCode> get allDtcCodes => _dtcCodes;
}
