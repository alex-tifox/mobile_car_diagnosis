import 'dart:convert';
import 'dart:typed_data';

import 'package:logger/logger.dart';

import '../service/command_response_recognizer.dart';

class ReceiveDataHandler {
  static final ReceiveDataHandler _instance = ReceiveDataHandler._internal();

  static ReceiveDataHandler get instance => _instance;

  ReceiveDataHandler._internal() {
    _receivedData = [];
  }

  final Logger _logger = Logger();

  List<int> _receivedData;

  void handleReceiveData(Uint8List data) {
    _logger.d(data);
    _logger.d(utf8.decode(data));
    var pureData =
        data.where((element) => element != 0x0D && element != 0x3E).toList();

    if (pureData.isEmpty) {
      CommandResponseRecognizer().recognizeCommandResponse(_receivedData);
      _receivedData = [];
    } else {
      _receivedData.addAll(pureData);
    }
  }
}
