import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:meta/meta.dart';

import '../../service/main_service.dart';
import '../../service/stream_facts/duplex_stream_fact.dart';

import 'bluetooth_stream_fact.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final MainService _mainService;
  StreamSubscription<ResponseStreamFact> _serviceToBlocListener;
  StreamSink<RequestStreamFact> _blocToServiceStreamIn;

  BluetoothBloc()
      : _mainService = MainService(),
        super(BluetoothInitial()) {
    _serviceToBlocListener =
        _mainService.serviceToBlocStreamOut.listen(_serviceToBlocHandler);
    _blocToServiceStreamIn = _mainService.blocToServiceStreamIn;
  }

  @override
  Stream<BluetoothState> mapEventToState(
    BluetoothEvent event,
  ) async* {
    /// Paired Devices request and response
    if (event is BluetoothRequestPairedDevicesEvent) {
      _blocToServiceStreamIn.add(BluetoothPairedDevicesRequest());
    } else if (event is BluetoothReceivedPairedDevicesEvent) {
      yield BluetoothPairedDevicesListState(
        pairedDevicesList: event.pairedDevices,
      );
    }

    /// Connect to device request and response
    else if (event is BluetoothConnectToDeviceEvent) {
      _blocToServiceStreamIn.add(
        BluetoothConnectToDeviceRequest(
          device: event.device,
        ),
      );
      yield BluetoothConnectDeviceInProcess();
    } else if (event is BluetoothDeviceConnectedEvent) {
      yield BluetoothConnectDeviceInProcess(connected: true);
    }
  }

  void _serviceToBlocHandler(ResponseStreamFact responseStreamFact) {
    if (responseStreamFact is BluetoothPairedDevicesResponse) {
      this.add(responseStreamFact.bluetoothReceivedPairedDevicesEvent);
    } else if (responseStreamFact is BluetoothDeviceConnectedResponse) {
      this.add(BluetoothDeviceConnectedEvent());
    }
  }

  @override
  Future<Function> close() {
    _serviceToBlocListener.cancel();
    _blocToServiceStreamIn.close();

    return super.close();
  }
}
