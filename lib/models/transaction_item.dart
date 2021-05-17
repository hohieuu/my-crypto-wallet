import 'package:secp256k1/secp256k1.dart';

enum TransactionType { RECEIVE, SEND }

class TransactionItem {
  TransactionType type;
  PublicKey partnerAddress;
  double amount;
  DateTime time;

  TransactionItem({this.type, this.partnerAddress, this.amount});

  static var templateData = [
    TransactionItem(
        type: TransactionType.RECEIVE,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 100),
    TransactionItem(
        type: TransactionType.RECEIVE,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 200),
    TransactionItem(
        type: TransactionType.SEND,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 300),
    TransactionItem(
        type: TransactionType.SEND,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 200),
    TransactionItem(
        type: TransactionType.RECEIVE,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 100),
    TransactionItem(
        type: TransactionType.RECEIVE,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 100),
    TransactionItem(
        type: TransactionType.SEND,
        partnerAddress: PrivateKey.generate().publicKey,
        amount: 100),
  ];
}
