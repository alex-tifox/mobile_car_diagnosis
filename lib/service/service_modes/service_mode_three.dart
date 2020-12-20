import '../../model/dtc_code.dart';

class ServiceModeThree {
  static final ServiceModeThree _instance = ServiceModeThree._internal();

  factory ServiceModeThree() {
    return _instance;
  }

  ServiceModeThree._internal();

  void calculateDtcCodes(List<String> carDecodedResponse) {
    List<List<String>> dtcData = new List();
    for (int i = 0; i < carDecodedResponse.length; i += 2) {
      dtcData.add(carDecodedResponse.sublist(i, i + 2));
    }

    // TODO: calculate short DTC code
  }

  void _prepareDataToSending(List<String> dtcDataCalculated) {
    List<DtcCode> dtcCodes = List();

    dtcDataCalculated.forEach((element) {
      dtcCodes.add(
        DtcCode(
          dtcShortName: element,
          dtcFullName: element,
          dtcDescription: 'description',
          dtcCauses: 'causes',
        ),
      );
    });

    _sendResponse(dtcCodes);
  }

  void _sendResponse(List<DtcCode> dtcCodes) {
    // TODO: send data to service or bloc
  }
}
