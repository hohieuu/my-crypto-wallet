enum TransactionType { RECEIVE, SEND }

class Transaction {
  TransactionType type;
  String txId;
  String receiver;
  String sender;
  double amount;
  DateTime time;

  Transaction(
      {this.txId,
      this.type,
      this.receiver,
      this.sender,
      this.amount,
      this.time});
  factory Transaction.fromJson(
      Map<String, dynamic> parsedJson, String myAddress) {
    TransactionType _type;
    var sender = parsedJson['sender'];
    var receiver = parsedJson['receiver'];
    if (myAddress == sender) {
      _type = TransactionType.SEND;
    }
    if (myAddress == receiver) {
      _type = TransactionType.RECEIVE;
    }
    return Transaction(
        receiver: parsedJson['receiver'],
        sender: parsedJson['sender'],
        amount: parsedJson['amount'].toDouble(),
        txId: parsedJson['txId'].toString(),
        time:
            DateTime.fromMicrosecondsSinceEpoch(parsedJson['timestamp'] * 1000),
        type: _type);
  }

  factory Transaction.fromJson2(Map<String, dynamic> parsedJson) {
    TransactionType _type;
    return Transaction(
        receiver: parsedJson['receiver'],
        sender: parsedJson['sender'],
        amount: parsedJson['amount'].toDouble(),
        txId: parsedJson['txId'].toString(),
        time:
            DateTime.fromMicrosecondsSinceEpoch(parsedJson['timestamp'] * 1000),
        type: _type);
  }
}
