import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../diagnosis/diagnosis_screen.dart';
import '../../blocs/bluetooth/bluetooth_bloc.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../configuration/custom_icons_icons.dart';
import '../connect_device/connect_device_screen.dart';

class StartScreen extends StatelessWidget {
  static const String route = '/start_screen';

  void _navigateToConnectDeviceScreen(BuildContext context) =>
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ConnectDeviceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 200),
        ),
      );

  void _showDeviceDisconnectedDialog(BuildContext context) {
    final Widget connectDeviceAlertDialog = AlertDialog(
      title: Text(
        'Currently device is disconnected',
      ),
      content: Text(
        'To start scanning for issues you need firstly connect to correct device',
      ),
      actions: [
        CustomElevatedButton(
          onPressed: (context) {
            Navigator.of(context).pop();
            _navigateToConnectDeviceScreen(context);
          },
          buttonText: 'Connect',
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) => connectDeviceAlertDialog,
    );
  }

  void _navigateToDiagnosisScreen(BuildContext context) {
    if (!BlocProvider.of<BluetoothBloc>(context).isConnected) {
      _showDeviceDisconnectedDialog(context);
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DiagnosisScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 200),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Diagnosis Mobile',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        elevation: 10.0,
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () => _navigateToConnectDeviceScreen(context),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 15.0,
            ),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToDiagnosisScreen(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          CustomIcons.car_repair,
                          size: 120,
                          color: Colors.white,
                        ),
                        Text(
                          'DIAGNOSTIC',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText2
                              .copyWith(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
