import 'package:flutter/material.dart';
import 'package:hhwallet/pages/wallet_main.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:flutter/services.dart';

class WalletCreate extends StatefulWidget {
  @override
  _WalletCreateState createState() => _WalletCreateState();
}

class _WalletCreateState extends State<WalletCreate> {
  PrivateKey newPrivateKey;
  bool copied;
  @override
  void initState() {
    super.initState();
    copied = false;
  }

  @override
  Widget build(BuildContext context) {
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
        margin: EdgeInsets.fromLTRB(10, 20, 10, 30),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: (newPrivateKey != null &&
                                newPrivateKey.toHex().length > 0)
                            ? null
                            : () {
                                setState(() {
                                  newPrivateKey = PrivateKey.generate();
                                });
                              },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    child: Icon(Icons.lock),
                                    padding: EdgeInsets.only(right: 10)),
                                Text(
                                  'Khởi tạo private key',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ))),
                    (newPrivateKey != null && newPrivateKey.toHex().length > 0)
                        ? SizedBox()
                        : SizedBox(),
                    (newPrivateKey != null && newPrivateKey.toHex().length > 0)
                        ? SizedBox()
                        : SizedBox()
                  ],
                )),
            (newPrivateKey != null && newPrivateKey.toHex().length > 0)
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('${newPrivateKey.toHex()}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.justify),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: double.infinity,
                        child: Container(
                          width: 100,
                          child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Copy ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: copied
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Icon(
                                    Icons.copy,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  copied = true;
                                });
                                Clipboard.setData(
                                    ClipboardData(text: newPrivateKey.toHex()));
                              }),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.orange),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Text(
                          'Đừng để mất, hãy cẩn thận, nếu mất nó sẽ không thể lấy lại được.',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.orange),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Text(
                          'Đừng chia sẻ nó, tiền của bạn sẽ bị đánh cắp nếu bạn chia sẻ chúng.',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(width: 1, color: Colors.orange)),
                        width: double.infinity,
                        child: Text(
                          'Sao lưu, bảo mật nó như hàng triệu đô la một ngày nào đó nó có thể có giá trị.',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            Spacer(),
            (newPrivateKey != null && newPrivateKey.toHex().length > 0)
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WalletMain(
                          privateKey: newPrivateKey,
                        ),
                      ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                          'Tôi đã sao lưu private key, tiến hành truy cập ví ',
                          style: TextStyle(fontSize: 15)),
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
