import 'package:flutter/material.dart';

abstract class DtcDetailsApiClient {
  Future<List<String>> getCarBrands();
  Future<Map<String, String>> getCodeFullData(
      {@required String carBrand, @required String dtcCodeToRequest});
}
