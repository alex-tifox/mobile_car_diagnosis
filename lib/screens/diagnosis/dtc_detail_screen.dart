import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/dtc_code.dart';
import '../../widgets/custom_circular_progress_indicator.dart';

class DtcDetailScreen extends StatefulWidget {
  final DtcCode _dtcCode;

  DtcDetailScreen({
    @required DtcCode dtcCode,
  }) : _dtcCode = dtcCode;

  @override
  _DtcDetailScreenState createState() => _DtcDetailScreenState();
}

class _DtcDetailScreenState extends State<DtcDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._dtcCode.dtcShortName),
      ),
      body: Container(
        child: BlocBuilder<DtcDetailsBloc, DtcDetailsState>(
          builder: (context, state) {
            if (state is DtcDetailsRequestInProgress) {
              return CustomCircularProgressIndicator();
            } else if (state is DtcDetailsReceived) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DtcDescription(
                      description: state.dtcCode.dtcDescription,
                    ),
                    _ListedDtcDetails(
                      listTitle: 'Symptoms',
                      listedData: state.dtcCode.dtcSymptoms,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: _ListedDtcDetails(
                        listTitle: 'Causes',
                        listedData: state.dtcCode.dtcCauses,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

/// Widget to display dtc code description
class _DtcDescription extends StatelessWidget {
  final String description;

  _DtcDescription({
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background,
      ),
      margin: EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10,
      ),
      padding: EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10,
        bottom: 16,
      ),
      child: Column(
        children: [
          _DtcBlockTitleText(
            title: 'Description',
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
            ),
            child: _DtcBlockText(
              dtcDetailText: description,
            ),
          )
        ],
      ),
    );
  }
}

/// Widget for displaying dtc details which is shown as list of causes,
/// symptoms etc
class _ListedDtcDetails extends StatelessWidget {
  final String listTitle;
  final List<String> listedData;

  _ListedDtcDetails({
    @required this.listTitle,
    @required this.listedData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
        left: 10,
        top: 16,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DtcBlockTitleText(title: listTitle),
          _DtcDetailsList(details: listedData),
        ],
      ),
    );
  }
}

class _DtcDetailsList extends StatelessWidget {
  final List<String> _details;

  _DtcDetailsList({
    @required List<String> details,
  }) : _details = details;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          top: 5,
          bottom: 0,
          width: 1,
          child: Container(
            height: 1000,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 6.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._details.map(
                (detail) => Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      VerticalDivider(),
                      _DtcDetailsListTile(
                        detail: detail,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DtcDetailsListTile extends StatelessWidget {
  final String detail;

  _DtcDetailsListTile({
    @required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: _DtcBlockText(
          dtcDetailText: detail,
        ),
      ),
    );
  }
}

class _DtcBlockTitleText extends StatelessWidget {
  final String _title;

  _DtcBlockTitleText({
    @required String title,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
    );
  }
}

class _DtcBlockText extends StatelessWidget {
  final String _dtcDetailText;

  _DtcBlockText({
    @required String dtcDetailText,
  }) : _dtcDetailText = dtcDetailText;

  @override
  Widget build(BuildContext context) {
    return Text(
      _dtcDetailText,
      style: Theme.of(context)
          .primaryTextTheme
          .bodyText2
          .copyWith(color: Colors.black),
    );
  }
}
