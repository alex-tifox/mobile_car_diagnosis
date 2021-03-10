part of 'dtc_details_bloc.dart';

@immutable
abstract class DtcDetailsEvent {}

class RequestDtcDetailsEvent extends DtcDetailsEvent {
  final DtcCode _dtcCode;

  RequestDtcDetailsEvent({
    @required DtcCode dtcCode,
  }) : _dtcCode = dtcCode;

  DtcCode get code => _dtcCode;
}
