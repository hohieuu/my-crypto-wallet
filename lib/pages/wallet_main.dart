import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hhwallet/main.dart';
import 'package:hhwallet/models/address_data.dart';
import 'package:hhwallet/models/transaction.dart';
import 'package:hhwallet/pages/send_coin.dart';
import 'package:hhwallet/pages/transaction_history.dart';
import 'package:hhwallet/resources/api_provider.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class WalletMain extends StatefulWidget {
  final PrivateKey privateKey;
  WalletMain({@required this.privateKey});
  @override
  _WalletMainState createState() => _WalletMainState();
}

class _WalletMainState extends State<WalletMain> {
  SharedPreferences _sharedPreferences;
  Future _fetchNetworkCall;
  @override
  void initState() {
    super.initState();
    saveData();
    // loadAddressData();
    _fetchNetworkCall = ApiProvider.getAddressData(
        widget.privateKey.publicKey.toCompressedHex());
  }

  void saveData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('private_key', widget.privateKey.toHex());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
        child: FutureBuilder<AddressData>(
          future: _fetchNetworkCall, // async work
          builder: (BuildContext context, AsyncSnapshot<AddressData> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Wallet'),
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      actions: [
                        IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Đăng xuất'),
                                    content: SizedBox(),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Huỷ'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Xác nhận'),
                                        onPressed: () {
                                          _sharedPreferences.clear();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) => MyHomePage(),
                                          ));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            })
                      ],
                    ),
                    body: Container(
                        child: ListView(children: [
                      Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          height: 235,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                stops: [
                                  0.1,
                                  0.9
                                ],
                                colors: [
                                  Colors.green[300],
                                  Colors.green[700],
                                ]),
                            // color: Colors.teal,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Address: ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '${widget.privateKey.publicKey.toCompressedHex()}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 15),
                                alignment: Alignment.center,
                                child: Text(
                                  '${snapshot.data.addressBalance} HH',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    RawMaterialButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => SendCoin(),
                                        ));
                                      },
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: Colors.red,
                                            size: 25.0,
                                          ),
                                          Text('Gửi')
                                        ],
                                      ),
                                      padding: EdgeInsets.all(15.0),
                                      shape: CircleBorder(),
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Container(
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    QrImage(
                                                      data:
                                                          "${widget.privateKey.publicKey.toCompressedHex()}",
                                                      version: QrVersions.auto,
                                                      size: 200.0,
                                                    ),
                                                    Padding(
                                                      child: Text(
                                                          widget.privateKey
                                                              .publicKey
                                                              .toCompressedHex(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                          )),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                    ),
                                                    ElevatedButton(
                                                      child: Icon(
                                                        Icons.copy,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text: widget
                                                                    .privateKey
                                                                    .publicKey
                                                                    .toCompressedHex()));
                                                      },
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 20),
                                                      color: Colors.white,
                                                      alignment:
                                                          Alignment.center,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .white)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                            Icons.cancel,
                                                            size: 100,
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                  ],
                                                )));
                                      },
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward,
                                            color: Colors.green,
                                            size: 25.0,
                                          ),
                                          Text('Nhận')
                                        ],
                                      ),
                                      padding: EdgeInsets.all(15.0),
                                      shape: CircleBorder(),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(right: 15),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              child: Text("Xem lịch sử theo address / txid",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TransactionHistory(),
                                ));
                              })),
                      for (Transaction item in snapshot.data == null
                          ? []
                          : snapshot.data.addressTransactions)
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  item.type == TransactionType.RECEIVE
                                      ? Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.green,
                                        ),
                                  Text(
                                    item.type == TransactionType.SEND
                                        ? '  Đã gửi'
                                        : '  Đã nhận',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Text(item.partnerAddress),
                              Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Text(
                                          '${DateFormat('dd/MM/yyyy – HH:mm:ss').format(item.time)}'),
                                      Spacer(),
                                      Text(
                                        '${item.amount} HH',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                              Divider(
                                height: 2,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        )
                    ])),
                  );
            }
          },
        ));
  }
}
