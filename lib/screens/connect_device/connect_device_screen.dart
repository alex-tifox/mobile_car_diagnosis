import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './widgets/paired_devices_list_widget.dart';
import '../../blocs/blocs.dart';
import '../../widgets/custom_elevated_button.dart';

class ConnectDeviceScreen extends StatefulWidget {
  static const String route = '/connect_device';
  @override
  _ConnectDeviceScreenState createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  void _swipeLeftNavigateBack(DragEndDetails dragEndDetails) =>
      dragEndDetails.primaryVelocity > 0 ? Navigator.of(context).pop() : null;

  void _disconnectFromDevice() => BlocProvider.of<BluetoothBloc>(context)
      .add(BluetoothDeviceDisconnectEvent());

  @override
  Widget build(BuildContext context) {
    Widget _disconnectedSnackBar = SnackBar(
      content: Text('Successfully disconnected'),
      backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(10.0),
      behavior: SnackBarBehavior.floating,
    );

    return GestureDetector(
      onHorizontalDragEnd: _swipeLeftNavigateBack,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Connect device'),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          elevation: 10.0,
        ),
        body: Container(
          child: BlocConsumer<BluetoothBloc, BluetoothState>(
            listener: (context, bluetoothState) {
              if (bluetoothState is BluetoothDeviceDisconnectedState) {
                Scaffold.of(context).showSnackBar(_disconnectedSnackBar);
              }
            },
            builder: (context, bluetoothState) {
              if (bluetoothState is BluetoothPairedDevicesListState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PairedDevicesListWidget(
                        pairedDevicesList: bluetoothState.pairedDevicesList,
                      ),
                    ),
                  ],
                );
              } else if (bluetoothState
                  is BluetoothConnectDeviceInProcessState) {
                if (!bluetoothState.connected) {
                  return Center(
                    child: Container(
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Text(
                          'You are connected to device:',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bluetoothState.device.name,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText2,
                                  ),
                                  Text(
                                    'ON',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText2
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: CustomElevatedButton(
                                onPressed: (_) => _disconnectFromDevice(),
                                buttonText: 'Disconnect',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (!BlocProvider.of<BluetoothBloc>(context).isConnected) {
      BlocProvider.of<BluetoothBloc>(context)
          .add(BluetoothRequestPairedDevicesEvent());
    }

    super.initState();
  }
}
