import 'package:hhwallet/models/transaction.dart';

class AddressData {
  List<Transaction> addressTransactions;
  double addressBalance;
  AddressData({this.addressTransactions, this.addressBalance});
  factory AddressData.fromJson(
      Map<String, dynamic> parsedJson, String myAddress) {
    var list = (parsedJson['addressTransactions'] as List)
        .map((data) => new Transaction.fromJson(data, myAddress))
        .toList();
    return AddressData(
        addressBalance: parsedJson['addressBalance'].toDouble(),
        addressTransactions: list);
  }
}
