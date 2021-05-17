import 'package:hhwallet/models/transaction.dart';

class AddressData {
  List<Transaction> addressTransactions;
  int addressBalance;
  AddressData({this.addressTransactions, this.addressBalance});
  factory AddressData.fromJson(
      Map<String, dynamic> parsedJson, String myAddress) {
    var list = (parsedJson['addressTransactions'] as List)
        .map((data) => new Transaction.fromJson(data, myAddress))
        .toList();
    print(list);
    return AddressData(
        addressBalance: parsedJson['addressBalance'],
        addressTransactions: list);
  }
}
