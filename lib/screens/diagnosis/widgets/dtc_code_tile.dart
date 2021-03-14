import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_car_diagnosis/blocs/blocs.dart';
import 'package:mobile_car_diagnosis/screens/diagnosis/dtc_detail_screen.dart';

import '../../../model/dtc_code.dart';

class DtcCodeTile extends StatelessWidget {
  final DtcCode _dtcCode;

  DtcCodeTile({
    @required DtcCode dtcCode,
  }) : _dtcCode = dtcCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: ListTile(
        title: Text(
          _dtcCode.dtcShortName,
          style: Theme.of(context)
              .primaryTextTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: _DtcCodeTileTrailingButton(
          dtcCode: _dtcCode,
        ),
      ),
    );
  }
}

class _DtcCodeTileTrailingButton extends StatelessWidget {
  final DtcCode _dtcCode;

  const _DtcCodeTileTrailingButton({
    @required DtcCode dtcCode,
  }) : _dtcCode = dtcCode;

  void _navigateToDtcDetailsScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          BlocProvider.of<DtcDetailsBloc>(context).add(
            RequestDtcDetailsEvent(dtcCode: _dtcCode),
          );
          return DtcDetailScreen(dtcCode: _dtcCode);
        },
        transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) =>
                ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeIn)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward_rounded),
      color: Colors.white,
      onPressed: () => _navigateToDtcDetailsScreen(context),
    );
  }
}
