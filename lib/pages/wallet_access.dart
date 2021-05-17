import 'package:flutter/material.dart';
import 'package:hhwallet/pages/wallet_main.dart';
import 'package:secp256k1/secp256k1.dart';

class WalletAccess extends StatefulWidget {
  @override
  _WalletAccessState createState() => _WalletAccessState();
}

class _WalletAccessState extends State<WalletAccess> {
  bool privateKeyValid;

  PrivateKey privateKey;
  String errorText;
  @override
  void initState() {
    super.initState();
    privateKeyValid = false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
            margin: EdgeInsets.fromLTRB(20, 100, 20, 30),
            color: Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: TextFormField(
                      controller: textEditingController,
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
                          border: UnderlineInputBorder(),
                          errorText:
                              (errorText != null && errorText.length != 0)
                                  ? errorText
                                  : null,
                          labelText: 'Nhập private key'),
                    ),
                  ),
                  Spacer(),
                  Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(children: [
                        ElevatedButton(
                            onPressed: privateKeyValid
                                ? () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => WalletMain(
                                        privateKey: privateKey,
                                      ),
                                    ));
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Text('Tiến hành truy cập ví ',
                                  style: TextStyle(fontSize: 18)),
                            ))
                      ])),
                ])));
  }
}
