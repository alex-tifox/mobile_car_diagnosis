import 'package:flutter/material.dart';

import 'package:mobile_car_diagnosis/blocs/dtc_bloc.dart';
import 'package:mobile_car_diagnosis/service/stream_facts/duplex_stream_fact.dart';

class DtcRequestStreamFact extends RequestDtcEvent {
  final RequestDtcEvent requestDtcEvent;

  DtcRequestStreamFact({
    @required this.requestDtcEvent,
  });
}

class DtcResponseStreamFact extends ResponseStreamFact {
  final ReceivedDtcEvent receivedDtcEvent;

  DtcResponseStreamFact({
    @required this.receivedDtcEvent,
  });
}
