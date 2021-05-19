import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hhwallet/models/transaction.dart';
import 'package:hhwallet/resources/api_provider.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  TextEditingController _searchController = new TextEditingController();
  String errorText = '';
  List<Transaction> _transactions = [];

  _loadData() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var results = await ApiProvider.search(_searchController.text);
    setState(() {
      _transactions = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử giao dịch'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Container(
                  width: width - 75,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: (errorText != null && errorText.length != 0)
                            ? errorText
                            : null,
                        labelText: 'Nhập address/txid cần tìm'),
                    controller: _searchController,
                    // child: Text('Tìm kiếm theo address'),
                    // onPressed: () {},
                  )),
              Container(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    _loadData();
                  },
                ),
              )
            ],
          ),
          for (var item in _transactions)
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'TxId: ${item.txId}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: _searchController.text == item.txId
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Time: ${DateFormat('dd/MM/yyyy – HH:mm:ss').format(item.time)}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Sender: ${item.sender}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: _searchController.text == item.sender
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Receiver: ${item.receiver}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: _searchController.text == item.receiver
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Amount: ${item.amount}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
