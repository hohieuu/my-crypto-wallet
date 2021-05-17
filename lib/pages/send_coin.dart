import 'package:flutter/material.dart';
import 'package:secp256k1/secp256k1.dart';

class SendCoin extends StatefulWidget {
  @override
  _SendCoinState createState() => _SendCoinState();
}

class _SendCoinState extends State<SendCoin> {
  TextEditingController targetAddressController, quantityController;
  String errorText;
  bool privateKeyValid, quantityValid;
  PrivateKey privateKey;

  @override
  void initState() {
    super.initState();
    privateKeyValid = false;
    quantityValid = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gửi coin'),
        ),
        body: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 20, bottom: 30, left: 5, right: 5),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: targetAddressController,
                    onChanged: (text) {
                      errorText = null;
                      if (text.length == 64) {
                        try {
                          privateKey = PrivateKey.fromHex(text);
                          setState(() {
                            privateKeyValid = true;
                          });
                        } catch (ignore) {
                          setState(() {
                            privateKeyValid = false;
                            errorText = 'Không hợp lệ';
                          });
                        }
                      } else
                        setState(() {
                          privateKeyValid = false;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: (errorText != null && errorText.length != 0)
                            ? errorText
                            : null,
                        labelText: 'Địa chỉ người nhận'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      errorText = null;
                      if (text != '' && int.parse(text) > 0) {
                        try {
                          setState(() {
                            quantityValid = true;
                          });
                        } catch (ignore) {
                          setState(() {
                            quantityValid = false;
                            errorText = 'Không hợp lệ';
                          });
                        }
                      } else
                        setState(() {
                          quantityValid = false;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: (errorText != null && errorText.length != 0)
                            ? errorText
                            : null,
                        labelText: 'Số lượng'),
                  ),
                ),
                Spacer(),
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(children: [
                      ElevatedButton(
                          onPressed: privateKeyValid && quantityValid
                              ? () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) => WalletMain(
                                  //     privateKey: privateKey,
                                  //   ),
                                  // ));
                                }
                              : null,
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: Text('Gửi', style: TextStyle(fontSize: 18)),
                          ))
                    ])),
              ],
            )));
  }
}
