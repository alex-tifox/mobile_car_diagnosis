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

  BluetoothDevice _connectedDevice;

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
      _handleRequestPairedDevice();
    } else if (event is BluetoothReceivedPairedDevicesEvent) {
      yield BluetoothPairedDevicesListState(
        pairedDevicesList: event.pairedDevices,
      );
    }

    /// Connect to device request and response
    else if (event is BluetoothConnectToDeviceEvent) {
      _blocToServiceStreamIn.add(
        BluetoothRequest(
          requestName: BluetoothRequestName.connect_device,
          device: event.device,
        ),
      );
      yield BluetoothConnectDeviceInProcessState();
    } else if (event is BluetoothDeviceConnectedEvent) {
      yield BluetoothConnectDeviceInProcessState(
        connected: true,
        device: event.device,
      );
    } else if (event is BluetoothDeviceDisconnectEvent) {
      _blocToServiceStreamIn.add(
        BluetoothRequest(
          requestName: BluetoothRequestName.disconnect_device,
        ),
      );
    } else if (event is BluetoothDeviceDisconnectedEvent) {
      _handleRequestPairedDevice();
      yield BluetoothDeviceDisconnectedState();
    }
  }

  void _serviceToBlocHandler(ResponseStreamFact responseStreamFact) {
    if (responseStreamFact is BluetoothResponse) {
      switch (responseStreamFact.responseName) {
        case BluetoothResponseName.paired_devices:
          this.add(
            BluetoothReceivedPairedDevicesEvent(
              pairedDevices: responseStreamFact.pairedDevices,
            ),
          );

          break;

        case BluetoothResponseName.device_connected:
          this.add(
            BluetoothDeviceConnectedEvent(
              device: responseStreamFact.device,
            ),
          );

          break;
        case BluetoothResponseName.device_disconnected:
          this.add(BluetoothDeviceDisconnectedEvent());
          break;
      }
    }
  }

  void _handleRequestPairedDevice() => _blocToServiceStreamIn.add(
        BluetoothRequest(
          requestName: BluetoothRequestName.paired_devices,
        ),
      );

  @override
  Future<Function> close() {
    _serviceToBlocListener.cancel();
    _blocToServiceStreamIn.close();

    return super.close();
  }
}
