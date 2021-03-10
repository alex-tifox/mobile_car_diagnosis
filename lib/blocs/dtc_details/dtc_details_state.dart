part of 'dtc_details_bloc.dart';

@immutable
abstract class DtcDetailsState {}

class DtcDetailsInitial extends DtcDetailsState {}

class DtcDetailsRequestInProgress extends DtcDetailsState {}

class DtcDetailsReceived extends DtcDetailsState {
  final DtcCode dtcCode;

  DtcDetailsReceived({
    @required this.dtcCode,
  });
}
