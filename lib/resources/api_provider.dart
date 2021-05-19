import 'dart:convert';

import 'package:hhwallet/models/address_data.dart';
import 'package:hhwallet/models/transaction.dart';
import 'package:secp256k1/secp256k1.dart';

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
    result = new AddressData.fromJson(response, address);
    return result;
  }

  static Future<List<Transaction>> search(String addressOrTxId) async {
    List<Transaction> results;
    final response = await getApiBaseHelper().get("search/$addressOrTxId");
    print(response);
    results = (response as List)
        .map((data) => new Transaction.fromJson2(data))
        .toList();
    return results;
  }

  static Future<dynamic> sendCoin(String signature, String publicKey,
      String receiverAddress, double amount) async {
    Object body = {
      "sender": "$publicKey",
      "receiver": '$receiverAddress',
      "amount": amount,
      "signature": "$signature"
    };
    var jsonBody = jsonEncode(body);
    print(jsonBody);
    try {
      final response = await getApiBaseHelper().post("transaction", jsonBody);
    } catch (err) {
      return {"successful": false, "message": err.toString()};
    }

    return {"successful": true, "message": "successful"};
  }
}
