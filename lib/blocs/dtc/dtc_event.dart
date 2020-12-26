part of 'dtc_bloc.dart';

@immutable
abstract class DtcEvent {}

class RequestDtcEvent extends DtcEvent {}

class ReceivedDtcEvent extends DtcEvent {
  final List<DtcCode> dtcCodesList;

  ReceivedDtcEvent({
    @required this.dtcCodesList,
  });
}
