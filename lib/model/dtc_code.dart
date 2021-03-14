import 'package:flutter/material.dart';

class DtcCode {
  final String dtcShortName;
  final List<String> dtcSymptoms;
  final String dtcDescription;
  final List<String> dtcCauses;

  final String _possibleCausesJsonKey = 'possiblesCauses';
  final String _possibleSymptomsJsonKey = 'possibleSymptoms';
  final String _descriptionJsonKey = 'description';

  DtcCode({
    @required this.dtcShortName,
    @required this.dtcSymptoms,
    @required this.dtcDescription,
    @required this.dtcCauses,
  });

  DtcCode copyWith({
    String dtcShortName,
    List<String> dtcSymptoms,
    String dtcDescription,
    List<String> dtcCauses,
  }) {
    if ((dtcShortName == null || identical(dtcShortName, this.dtcShortName)) &&
        (dtcSymptoms == null || identical(dtcSymptoms, this.dtcSymptoms)) &&
        (dtcDescription == null ||
            identical(dtcDescription, this.dtcDescription)) &&
        (dtcCauses == null || identical(dtcCauses, this.dtcCauses))) {
      return this;
    }

    return DtcCode(
      dtcShortName: dtcShortName ?? this.dtcShortName,
      dtcSymptoms: dtcSymptoms ?? this.dtcSymptoms,
      dtcDescription: dtcDescription ?? this.dtcDescription,
      dtcCauses: dtcCauses ?? this.dtcCauses,
    );
  }

  DtcCode addDataFromJson(Map<String, String> json) {
    return copyWith(
      dtcDescription: json[_descriptionJsonKey],
      dtcCauses: _trimAndRemove(json[_possibleCausesJsonKey].split('-')),
      dtcSymptoms: _trimAndRemove(json[_possibleSymptomsJsonKey].split('-')),
    );
  }

  List<String> _trimAndRemove(List<String> list) {
    list.removeWhere((element) => element.trim().isEmpty);
    return list.map((element) => element.trim()).toList();
  }
}
