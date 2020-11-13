import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  BluetoothBloc() : super(BluetoothInitial());

  @override
  Stream<BluetoothState> mapEventToState(
    BluetoothEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
