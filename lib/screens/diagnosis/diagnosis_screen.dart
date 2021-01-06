import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/diagnosis/widgets/dtc_code_expansion_tile.dart';
import '../../blocs/blocs.dart';
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
                        ...dtcState.dtcCodesList
                            .map((dtc) => DtcCodeExpansionTile(dtcCode: dtc)),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'You can start scanning for issues',
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                    ),
                    CustomElevatedButton(
                      onPressed: _startScanForDtc,
                      buttonText: 'START',
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
