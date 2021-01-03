import 'package:flutter/material.dart';

import '../diagnosis/diagnosis_screen.dart';
import '../connect_device/connect_device_screen.dart';

class StartScreen extends StatelessWidget {
  static const String route = '/start_screen';

  _navigateToConnectDeviceScreen(BuildContext context) =>
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

  _navigateToDiagnosisScreen(BuildContext context) =>
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
                    child: Text('Diagnose'),
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
