import '../../model/dtc_code.dart';
import '../main_service.dart';

class ServiceModeThree {
  MainService _mainService;
  static final ServiceModeThree _instance = ServiceModeThree._internal();

  factory ServiceModeThree() {
    return _instance;
  }

  ServiceModeThree._internal() {
    _mainService = MainService();
  }

  List<String> dtcLetters = ['P', 'C', 'B', 'U'];

  void calculateDtcCodes(String carDecodedResponse) {
    List<String> dtcData = new List();
    for (int i = 0; i < carDecodedResponse.length; i += 4) {
      dtcData.add(carDecodedResponse.substring(i, i + 4));
    }

    List<String> dtcDecoded = List();
    for (String value in dtcData) {
      int firstByte = _charToByte(value.substring(0, 1));
      int firstChar = (firstByte & 0xC0) >> 6;
      int secondChar = (firstByte & 0x30) >> 4;

      String dtcParsed = '';
      dtcParsed += dtcLetters[firstChar];
      dtcParsed += secondChar.toString();
      dtcParsed += value.substring(1, 4);

      dtcDecoded.add(dtcParsed);
    }

    _prepareAndSendData(dtcDecoded);
  }

  void _prepareAndSendData(List<String> dtcDataCalculated) {
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
    _mainService.handleReceivedDtcCodes(dtcCodes);
  }

  int _charToByte(String char) {
    assert(char.length == 1);
    return (int.parse(char, radix: 16) << 4);
  }
}
