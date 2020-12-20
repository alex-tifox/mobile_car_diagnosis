import 'dart:typed_data';

import 'package:mobile_car_diagnosis/service/command_response_recognizer.dart';

class ReceiveDataHandler {
  static final ReceiveDataHandler _instance = ReceiveDataHandler._internal();

  factory ReceiveDataHandler() {
    return _instance;
  }

  ReceiveDataHandler._internal() {
    receivedData = Uint8List(7);
  }

  Uint8List receivedData;

  void handleReceiveData(Uint8List data) {
    data.removeWhere((element) => element == 0x0D || element == 0x3E);
    if (data.isEmpty) {
      CommandResponseRecognizer().recognizeCommandResponse(receivedData);
    } else {
      receivedData.addAll(data);
    }
  }
}
