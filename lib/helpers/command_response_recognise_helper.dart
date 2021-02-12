import 'dart:convert';

import 'package:logger/logger.dart';

import '../service/service_modes/service_mode_three.dart';

class CommandResponseRecogniseHelper {
  final Logger _logger = Logger();

  void recognizeCommandResponse(List<int> response) {
    if (response.isNotEmpty) {
      var decodedResponse = utf8.decode(response);
      if (decodedResponse.substring(0, 2) == '43') {
        _logger.d('Decoded response is $decodedResponse');
        ServiceModeThree().calculateDtcCodes(decodedResponse.substring(2));
      } else {
        _logger.d('Unhandled Data: $decodedResponse');
      }
    }
  }
}
