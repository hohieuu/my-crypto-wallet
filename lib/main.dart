import 'package:flutter/material.dart';
import 'package:hhwallet/pages/wallet_access.dart';
import 'package:hhwallet/pages/wallet_main.dart';
import 'package:hhwallet/pages/wallet_create.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  PrivateKey privateKey;

  if (prefs != null) {
    try {
      if (prefs.getString('private_key') != null)
        privateKey = PrivateKey.fromHex(prefs.getString('private_key'));
    } catch (err) {
      print(err);
    }
  }
  runApp(MyApp(
    privateKey: privateKey,
  ));
}

const PrimaryColor = const Color(0xFF151026);

class MyApp extends StatelessWidget {
  final PrivateKey privateKey;
  MyApp({this.privateKey});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HH wallet',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: privateKey != null
          ? WalletMain(privateKey: privateKey)
          : MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'HH Wallet',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Thiết lập ví',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Nhập một ví hiện tại hoặc tạo ví mới',
                    style: TextStyle(),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WalletCreate(),
                        ));
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          'Tạo một ví với',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                ),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WalletAccess(),
                        ));
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          'Đã có ví, truy cập bằng private key',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
