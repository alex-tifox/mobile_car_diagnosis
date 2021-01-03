import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../blocs/dtc/dtc_bloc.dart';

class DiagnosisScreen extends StatelessWidget {
  void _startScanForDtc(BuildContext context) =>
      BlocProvider.of<DtcBloc>(context).add(RequestDtcEvent());

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
      ),
      body: Container(
        child: BlocBuilder<DtcBloc, DtcState>(
          builder: (context, dtcState) {
            if (dtcState is DtcReceivedState) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ...dtcState.dtcCodesList.map(
                          (dtc) => ExpansionTile(
                            title: Text(dtc.dtcShortName),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Text('You can start scanning for issues'),
                  CustomElevatedButton(
                    onPressed: _startScanForDtc,
                    buttonText: 'START',
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
