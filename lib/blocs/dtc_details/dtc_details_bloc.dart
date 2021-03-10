import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_car_diagnosis/service/main_service.dart';

import '../../model/dtc_code.dart';
import '../../service/locator.dart';

part 'dtc_details_event.dart';
part 'dtc_details_state.dart';

class DtcDetailsBloc extends Bloc<DtcDetailsEvent, DtcDetailsState> {
  final MainService _mainService;
  DtcDetailsBloc()
      : _mainService = locator.get<MainService>(),
        super(DtcDetailsInitial());

  @override
  Stream<DtcDetailsState> mapEventToState(
    DtcDetailsEvent event,
  ) async* {
    if (event is RequestDtcDetailsEvent) {
      yield DtcDetailsRequestInProgress();
      final fullDtcCode = await _mainService.getFullDataForDtcCode(
        carBrand: 'Audi',
        dtcCodeToRequest: event.code,
      );
      yield DtcDetailsReceived(dtcCode: fullDtcCode);
    }
  }
}
