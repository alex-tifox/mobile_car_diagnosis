import 'dart:convert';
import 'dart:typed_data';

import 'package:logger/logger.dart';

import './service_modes/service_mode_three.dart';

class CommandResponseRecognizer {
  Logger _logger = Logger();

  void recognizeCommandResponse(Uint8List response) {
    if (response.isNotEmpty) {
      String decodedResponse = utf8.decode(response);
      if (decodedResponse.substring(0, 2) == '43') {
        ServiceModeThree().calculateDtcCodes(decodedResponse.substring(2));
      } else {
        _logger.d('Unhandled Data: $decodedResponse');
      }
    }
  }
}
