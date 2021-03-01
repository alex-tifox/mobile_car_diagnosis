import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/dtc_code.dart';
import '../../service/locator.dart';
import '../../service/main_service.dart';
import '../../service/stream_facts/duplex_stream_fact.dart';
import 'dtc_stream_fact.dart';

part 'dtc_event.dart';
part 'dtc_state.dart';

class DtcBloc extends Bloc<DtcEvent, DtcState> {
  final MainService _mainService;
  StreamSubscription<ResponseStreamFact> _serviceToBlocListener;
  StreamSink<RequestStreamFact> _blocToServiceStreamIn;

  DtcBloc()
      : _mainService = locator.get<MainService>(),
        super(DtcInitial()) {
    _serviceToBlocListener =
        _mainService.serviceToBlocStreamOut.listen(_serviceToBlocHandler);
    _blocToServiceStreamIn = _mainService.blocToServiceStreamIn;
  }

  @override
  Stream<DtcState> mapEventToState(
    DtcEvent event,
  ) async* {
    if (event is RequestDtcEvent) {
      _blocToServiceStreamIn.add(
        DtcRequestStreamFact(
          requestDtcEvent: event,
        ),
      );
    } else if (event is ReceivedDtcEvent) {
      yield DtcReceivedState(
        dtcCodesList: event.dtcCodesList,
      );
    }
  }

  void _serviceToBlocHandler(ResponseStreamFact responseStreamFact) {
    if (responseStreamFact is DtcResponseStreamFact) {
      add(responseStreamFact.receivedDtcEvent);
    }
  }

  @override
  Future<Function> close() {
    _serviceToBlocListener.cancel();
    _blocToServiceStreamIn.close();

    return super.close();
  }
}
