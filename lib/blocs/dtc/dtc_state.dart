part of 'dtc_bloc.dart';

@immutable
abstract class DtcState {}

class DtcInitial extends DtcState {}

class DtcReceivedState extends DtcState {
  final List<DtcCode> dtcCodesList;

  DtcReceivedState({
    @required this.dtcCodesList,
  });
}
