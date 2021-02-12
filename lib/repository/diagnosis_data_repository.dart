import '../model/dtc_code.dart';

class DiagnosisDataRepository {
  final List<DtcCode> _dtcCodes = [];

  void addDtcCode(DtcCode dtcCode) {
    _dtcCodes.add(dtcCode);
  }

  List<DtcCode> get allDtcCodes => _dtcCodes;
}
