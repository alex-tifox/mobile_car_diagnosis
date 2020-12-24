import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_car_diagnosis/model/dtc_code.dart';

part 'dtc_event.dart';
part 'dtc_state.dart';

class DtcBloc extends Bloc<DtcEvent, DtcState> {
  DtcBloc() : super(DtcInitial());

  @override
  Stream<DtcState> mapEventToState(
    DtcEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
