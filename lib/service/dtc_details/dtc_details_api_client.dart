import 'package:flutter/material.dart';

abstract class DtcDetailsApiClient {
  Future<List<String>> getCarBrands();
  Future<Map<String, dynamic>> getCodeFullData(
      {@required String carBrand, @required String dtcCodeToRequest});
}
