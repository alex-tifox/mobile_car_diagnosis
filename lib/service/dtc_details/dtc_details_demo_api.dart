import './dtc_details_api_client.dart';
import '../../service/dtc_details/demo_data.dart';

class DtcDetailsDemoApi implements DtcDetailsApiClient {
  static final _p0500 = 'P0500';
  static final _p0174 = 'P0174';

  @override
  Future<List<String>> getCarBrands() async {
    await Future.delayed(Duration(seconds: 1));
    return DemoData.carBrands;
  }

  @override
  Future<Map<String, dynamic>> getCodeFullData({
    String carBrand,
    String dtcCodeToRequest,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    assert(dtcCodeToRequest != null);

    if (dtcCodeToRequest == _p0174) {
      return DemoData.p0174DtcCode;
    } else if (dtcCodeToRequest == _p0500) {
      return DemoData.p0500DtcCode;
    } else {
      return <String, dynamic>{};
    }
  }
}
