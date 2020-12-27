import 'package:flutter/material.dart';

import 'dtc_bloc.dart';
import '../../service/stream_facts/duplex_stream_fact.dart';

class DtcRequestStreamFact extends RequestStreamFact {
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
