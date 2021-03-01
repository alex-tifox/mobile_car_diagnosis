import '../../model/dtc_code.dart';
import '../locator.dart';
import '../main_service.dart';

class ServiceModeThree {
  MainService _mainService;
  static final ServiceModeThree _instance = ServiceModeThree._internal();

  factory ServiceModeThree() {
    return _instance;
  }

  ServiceModeThree._internal() {
    _mainService = locator.get<MainService>();
  }

  List<String> dtcLetters = ['P', 'C', 'B', 'U'];

  void calculateDtcCodes(String carDecodedResponse) {
    var dtcData = <String>[];
    for (var i = 0; i < carDecodedResponse.length; i += 4) {
      dtcData.add(carDecodedResponse.substring(i, i + 4));
    }

    var dtcDecoded = <String>[];
    for (var value in dtcData) {
      var firstByte = _charToByte(value.substring(0, 1));
      var firstChar = (firstByte & 0xC0) >> 6;
      var secondChar = (firstByte & 0x30) >> 4;

      var dtcParsed = '';
      dtcParsed += dtcLetters[firstChar];
      dtcParsed += secondChar.toString();
      dtcParsed += value.substring(1, 4);
      if (dtcParsed != 'P0000') {
        dtcDecoded.add(dtcParsed);
      }
    }

    _prepareAndSendData(dtcDecoded);
  }

  void _prepareAndSendData(List<String> dtcDataCalculated) {
    var dtcCodes = <DtcCode>[];

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
