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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DtcDescription(
                    description: state.dtcCode.dtcDescription,
                  ),
                  _ListedDtcDetails(
                    listTitle: 'Symptoms',
                    listedData: state.dtcCode.dtcSymptoms,
                  ),
                  _ListedDtcDetails(
                    listTitle: 'Causes',
                    listedData: state.dtcCode.dtcCauses,
                  ),
                ],
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
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Colors.black),
          ),
          Text(
            description,
            style: Theme.of(context)
                .primaryTextTheme
                .bodyText2
                .copyWith(color: Colors.black),
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
    return Column(
      children: [
        ...listedData.map(
          (detail) => _DtcDetailsListTile(detail: detail),
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
    return ListTile(
      title: Text(detail),
    );
  }
}
