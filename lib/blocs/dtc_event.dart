part of 'dtc_bloc.dart';

@immutable
abstract class DtcEvent {}

class RequestDtcEvent extends DtcEvent {}

class ReceivedDtcEvent extends DtcEvent {
  final DtcReceivedState diagnosticTroubleCodesReceivedState;

  ReceivedDtcEvent({
    @required this.diagnosticTroubleCodesReceivedState,
  });
}
