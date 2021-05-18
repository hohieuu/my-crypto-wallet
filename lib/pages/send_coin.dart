import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hhwallet/resources/api_provider.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:toast/toast.dart';

class SendCoin extends StatefulWidget {
  final PrivateKey senderPrivateKey;
  final double amount;
  SendCoin({this.senderPrivateKey, this.amount});
  @override
  _SendCoinState createState() => _SendCoinState();
}

class _SendCoinState extends State<SendCoin> {
  TextEditingController receiverAddressController = new TextEditingController(),
      amountController = new TextEditingController();
  String errorText, errorText2;
  bool publicKeyValid = false, amountValid = false;
  PublicKey publicKey;

  @override
  void initState() {
    super.initState();
    publicKeyValid = false;
    amountValid = false;
  }

  sendTransaction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final double amount = double.parse(amountController.text);
    final senderAddress = widget.senderPrivateKey.publicKey.toCompressedHex();

    final receiverAddress = receiverAddressController.text;
    final message = senderAddress + receiverAddress + amountController.text;
    print(message);
    var bytes1 = utf8.encode(message);
    var digest1 = sha256.convert(bytes1);
    Signature signature = widget.senderPrivateKey.signature('$digest1');
    print('private key ${widget.senderPrivateKey.toHex()}');
    print('public key ${widget.senderPrivateKey.publicKey}');
    print(signature.verify(widget.senderPrivateKey.publicKey, '$digest1'));
    print('message $digest1');
    print('signature:' + signature.toString());
    print('signature:' + signature.toString());
    print('signature: ${signature.toHexes()}');
    var data = await ApiProvider.sendCoin(
        signature.toRawHex(), senderAddress, receiverAddress, amount);

    if (data['successful']) {
      Navigator.of(context).pop();
      Toast.show('Thành công', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show(data['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
                    controller: receiverAddressController,
                    onChanged: (text) {
                      print(text.length);
                      errorText = null;
                      if (text.length >= 64) {
                        try {
                          // publicKey = publicKey.fromHex(text);
                          setState(() {
                            if (widget.senderPrivateKey.publicKey
                                    .toCompressedHex() ==
                                text)
                              setState(() {
                                publicKeyValid = false;
                                errorText = 'Trùng với địa chỉ ví hiện tại';
                              });
                            else
                              publicKeyValid = true;
                          });
                        } catch (ignore) {
                          setState(() {
                            publicKeyValid = false;
                            errorText = 'Không hợp lệ';
                          });
                        }
                      } else
                        setState(() {
                          publicKeyValid = false;
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
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      errorText2 = null;
                      if (text != '' && double.parse(text) > 0) {
                        try {
                          setState(() {
                            amountValid = true;
                          });
                        } catch (ignore) {
                          setState(() {
                            amountValid = false;
                            errorText2 = 'Không hợp lệ';
                          });
                        }
                      } else
                        setState(() {
                          amountValid = false;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText:
                            (errorText2 != null && errorText2.length != 0)
                                ? errorText2
                                : null,
                        labelText: 'Số lượng'),
                  ),
                ),
                Spacer(),
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(children: [
                      ElevatedButton(
                          onPressed: publicKeyValid && amountValid
                              ? () {
                                  sendTransaction();
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
