import 'package:flutter/material.dart';

class DtcCode {
  final String dtcShortName;
  final String dtcFullName;
  final String dtcDescription;
  final String dtcCauses;

  const DtcCode({
    @required this.dtcShortName,
    @required this.dtcFullName,
    @required this.dtcDescription,
    @required this.dtcCauses,
  });
}
