import 'package:secp256k1/secp256k1.dart';

enum TransactionType { RECEIVE, SEND }

class Transaction {
  TransactionType type;
  String partnerAddress;
  double amount;
  DateTime time;

  Transaction({this.type, this.partnerAddress, this.amount, this.time});
  factory Transaction.fromJson(
      Map<String, dynamic> parsedJson, String myAddress) {
    // var isNull = parsedJson['data'] == null;
    var _partnerAddress;
    TransactionType _type;
    var sender = parsedJson['sender'];
    var receiver = parsedJson['receiver'];
    if (myAddress == sender) {
      _partnerAddress = receiver;

      print('partner' + receiver);
      _type = TransactionType.SEND;
    }
    if (myAddress == receiver) {
      print('partner' + sender);
      _partnerAddress = sender;
      _type = TransactionType.RECEIVE;
    }
    return Transaction(
        partnerAddress: _partnerAddress,
        amount: parsedJson['amount'].toDouble(),
        time:
            DateTime.fromMicrosecondsSinceEpoch(parsedJson['timestamp'] * 1000),
        type: _type);
  }
  // static var templateData = [
  //   Transaction(
  //       type: TransactionType.RECEIVE,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 100),
  //   Transaction(
  //       type: TransactionType.RECEIVE,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 200),
  //   Transaction(
  //       type: TransactionType.SEND,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 300),
  //   Transaction(
  //       type: TransactionType.SEND,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 200),
  //   Transaction(
  //       type: TransactionType.RECEIVE,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 100),
  //   Transaction(
  //       type: TransactionType.RECEIVE,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 100),
  //   Transaction(
  //       type: TransactionType.SEND,
  //       partnerAddress: PrivateKey.generate().publicKey,
  //       amount: 100),
  // ];
}
