import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:logger/logger.dart';

import '../commands/obd_command.dart';
import '../blocs/blocs.dart';
import '../blocs/stream_facts.dart';
import '../model/dtc_code.dart';
import '../repository/diagnosis_data_repository.dart';
import '../service/command_response_recognizer.dart';
import '../service/bluetooth_connection_service.dart';
import '../service/stream_facts/duplex_stream_fact.dart';

class MainService {
  /// Stream controller designed for controlling stream for sending data to bloc
  /// and receive requests from user interface
  StreamController<ResponseStreamFact> _serviceToBlocStreamController;

  /// Stream sink to send data from service to UI. Is set in the [MainService]
  /// constructor. To send data to bloc used abstraction of [ResponseStreamFact]
  /// with exact Bloc's StreamFact to send required data to any Bloc.
  StreamSink<ResponseStreamFact> _serviceToBlocStreamIn;

  Stream<ResponseStreamFact> _serviceToBlocStreamOut;

  /// Stream controller designed for controlling stream for sending requests to
  /// service and responses to user interface
  StreamController<RequestStreamFact> _blocToServiceStreamController;

  StreamSink<RequestStreamFact> _blocToServiceStreamIn;
  StreamSubscription<RequestStreamFact> _blocToServiceStreamListener;

  DiagnosisDataRepository _dataRepository;
  BluetoothConnectionService _bluetoothConnectionService;
  Logger _logger = Logger();
  static final MainService _instance = MainService._internal();

  factory MainService() {
    return _instance;
  }

  MainService._internal() {
    _serviceToBlocStreamController = StreamController<ResponseStreamFact>();
    _serviceToBlocStreamIn = _serviceToBlocStreamController.sink;
    _serviceToBlocStreamOut =
        _serviceToBlocStreamController.stream.asBroadcastStream();

    _blocToServiceStreamController = StreamController<RequestStreamFact>();
    _blocToServiceStreamIn = _blocToServiceStreamController.sink;
    _blocToServiceStreamListener = _blocToServiceStreamController.stream
        .listen(_fromBlocToServiceListener);
    _dataRepository = DiagnosisDataRepository();
    _bluetoothConnectionService = BluetoothConnectionService();
  }

  /// Stream used for listening for sent data from service in every Bloc.
  ///
  /// Because this stream is a broadcast stream, responses should be filtered
  /// and be navigated in the Bloc
  Stream<ResponseStreamFact> get serviceToBlocStreamOut =>
      _serviceToBlocStreamOut;

  StreamSink<RequestStreamFact> get blocToServiceStreamIn =>
      _blocToServiceStreamIn;

  void _fromBlocToServiceListener(RequestStreamFact requestStreamFact) async {
    /// Paired devices request and response
    if (requestStreamFact is BluetoothRequest) {
      switch (requestStreamFact.requestName) {
        case BluetoothRequestName.paired_devices:
          {
            List<BluetoothDevice> pairedDevices =
                await _bluetoothConnectionService.pairedDevicesList;

            _serviceToBlocStreamIn.add(
              BluetoothResponse(
                responseName: BluetoothResponseName.paired_devices,
                pairedDevices: pairedDevices,
              ),
            );
          }
          break;
        case BluetoothRequestName.connect_device:
          {
            await _bluetoothConnectionService
                .connectToDevice(requestStreamFact.device);
          }
          break;
        case BluetoothRequestName.disconnect_device:
          {
            await _bluetoothConnectionService.disconnectFromDevice();
          }
          break;
      }
    }

    /// Send request about DTCs
    else if (requestStreamFact is DtcRequestStreamFact) {
      await _sendCommand(ObdCommand.getAllDtcs);
    }
  }

  /// Method for bonding with [CommandResponseRecognizer] to receive the list
  /// of parsed DTC codes and store them at local storage.
  ///
  /// After storing this data, get codes from repository and send them to
  /// the bloc, all DTC codes should be got from repository, because
  /// data comes from ELM327 in on-air method:
  ///
  /// E.g. you have 4 DTCs in your vehicle, so the response will be as
  /// '43 0133 4356 010F' and '43 0235 0000 0000'
  ///
  /// Two commands which are parsed separately and data could be leaked without
  /// storage them after parsing
  void handleReceivedDtcCodes(List<DtcCode> dtcCodes) {
    dtcCodes.forEach((dtcCode) => _dataRepository.addDtcCode(dtcCode));

    _serviceToBlocStreamIn.add(
      DtcResponseStreamFact(
        receivedDtcEvent: ReceivedDtcEvent(
          dtcCodesList: _dataRepository.allDtcCodes,
        ),
      ),
    );
  }

  void handleDeviceConnected(BluetoothDevice device) {
    _serviceToBlocStreamIn.add(
      BluetoothResponse(
        responseName: BluetoothResponseName.device_connected,
        device: device,
      ),
    );
  }

  void handleDeviceDisconnected() {
    _serviceToBlocStreamIn.add(
      BluetoothResponse(
        responseName: BluetoothResponseName.device_disconnected,
      ),
    );
  }

  Future<void> _sendCommand(String command) async {
    await _bluetoothConnectionService.sendData(ObdCommand(command: command));
  }

  void dispose() {
    _bluetoothConnectionService.dispose();
    _logger.d('MainService disposed');
  }
}
