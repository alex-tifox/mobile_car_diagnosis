import 'dart:async';

import '../model/dtc_code.dart';
import '../repository/diagnosis_data_repository.dart';
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
  }

  /// Stream used for listening for sent data from service in every Bloc.
  ///
  /// Because this stream is a broadcast stream, responses should be filtered
  /// and be navigated in the Bloc
  Stream<ResponseStreamFact> get serviceToBlocStreamOut =>
      _serviceToBlocStreamOut;

  void _fromBlocToServiceListener(RequestStreamFact requestStreamFact) {}

  void handleReceivedDtcCodes(List<DtcCode> dtcCodes) =>
      dtcCodes.forEach((dtcCode) => _dataRepository.addDtcCode(dtcCode));
}
