import 'package:hhwallet/models/address_data.dart';

import 'api_helper.dart';

class ApiProvider {
  static ApiBaseHelper _helper;
  static clearApiBaseHelper() {
    _helper = null;
  }

  static ApiBaseHelper getApiBaseHelper() {
    if (_helper == null) {
      _helper = new ApiBaseHelper();
    }

    return _helper;
  }

  static Future<AddressData> getAddressData(String address) async {
    AddressData result;
    final response = await getApiBaseHelper().get("address/$address");
    print(response);
    result = new AddressData.fromJson(response, address);
    return result;
  }
}
