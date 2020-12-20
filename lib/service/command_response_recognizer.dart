import 'dart:typed_data';

import 'package:logger/logger.dart';
import './service_modes/service_mode_three.dart';

class CommandResponseRecognizer {
  Logger _logger = Logger();

  void recognizeCommandResponse(Uint8List response) {
    List<String> decodedResponse =
        response.map((byte) => byte.toRadixString(16)).toList();
    if (decodedResponse.first == '43') {
      ServiceModeThree().calculateDtcCodes(decodedResponse);
    } else {
      _logger.d('Unhandled Data: $decodedResponse');
    }
  }
}
