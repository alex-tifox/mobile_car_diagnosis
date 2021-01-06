import 'package:flutter/material.dart';

import '../../../model/dtc_code.dart';

class DtcCodeExpansionTile extends StatelessWidget {
  final DtcCode _dtcCode;

  DtcCodeExpansionTile({
    @required DtcCode dtcCode,
  }) : _dtcCode = dtcCode;

  Widget _buildDtcDetails(
    BuildContext context, {
    @required String detailTitle,
    @required String detailDescription,
  }) =>
      Container(
        child: Column(
          children: [
            Text(
              detailTitle,
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
            ),
            Text(
              detailDescription,
              style: Theme.of(context).primaryTextTheme.bodyText2,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).backgroundColor,
      ),
      child: Theme(
        data: ThemeData(
          backgroundColor: Theme.of(context).colorScheme.background,
          unselectedWidgetColor: Colors.white,
          accentColor: Colors.white,
          textTheme: TextTheme(
            subtitle1: TextStyle(
              color: Colors.white,
            ),
          ),
          dividerColor: Colors.white,
        ),
        child: ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: EdgeInsets.symmetric(horizontal: 15.0),
          title: Text(
            _dtcCode.dtcShortName,
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          collapsedBackgroundColor: Theme.of(context).colorScheme.primary,
          children: [
            _buildDtcDetails(
              context,
              detailTitle: 'Description',
              detailDescription: _dtcCode.dtcDescription,
            ),
            _buildDtcDetails(
              context,
              detailTitle: 'Causes',
              detailDescription: _dtcCode.dtcCauses,
            ),
          ],
        ),
      ),
    );
  }
}
