import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner/auth/currentvehicle.dart';
import 'package:scanner/auth/qrupdate.dart';
import 'auth/authenticator.dart';
import 'auth/currentauth.dart';
import 'auth/readCur.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scan Me My Dudes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final val = '';
  int _counter = 0;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String code = "";
  String resultcode = "";
  String testtext = "";
  TextEditingController CurrntPopu = new TextEditingController();
  var qrTextController;

  //final Cur Current1;

  //_MyHomePageState(this.Current1);

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  Barcode? barcode;
  QRViewController? controller1;

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(
            top: 20,
            child: buildTextResult(),
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildEntryResult(),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildExitResult(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void Size() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('vehiclepop').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          //final data = docs[i].data();data['current'],
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();

                return ListTile(
                  title: Text(
                    data['current'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      );
  Widget Checker() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('vehiclepop').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          //final data = docs[i].data();data['current'],
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();

                return ListTile(
                  title: Text(
                    data['current'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      );
  Widget buildTextResult() => Text(
        barcode != null ? 'REsult :${barcode!.code}' : 'scanned',
      );

  Widget
      buildEntryResult() => /*ElevatedButton(
        //barcode != null ? 'REsult :${barcode!.code}' : 'scanned',

        child: const Text('ENTRY'),
        onPressed: () async {
          if (barcode!.code.toString().substring(0, 3) == "pnpguest") {
            await Authentication().createGuest(Entry(
                qr: barcode!.code.toString(),
                state: "In",
                datetime: DateTime.now().toString()));
            CurrAuthentication().updateGuestCountAdd();
          } else {}
        },
      );*/
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('vehiclepop').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');
              //final data = docs[i].data();data['current'],
              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;

                final curr = docs.map((data) => data['current']).toList();
                return ElevatedButton(
                  child: Text("Entry"),
                  onPressed: () async {
                    if (barcode!.code.toString().substring(0, 3) == "pnp") {
                      if (/*barcode!.code.toString().substring(0, 3)*/ curr
                              .toString() ==
                          "[220]") {
                      } else {
                        await Authentication().createGuest(Entry(
                            qr: barcode!.code.toString(),
                            state: "In",
                            datetime: DateTime.now().toString()));
                        CurrAuthentication().updateGuestCountAdd();
                      }
                    } else {}
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );
  Widget
      buildExitResult() => /*ElevatedButton(
        //barcode != null ? 'REsult :${barcode!.code}' : 'scanned',
        onPressed: () async {
          if (/*barcode!.code.toString().substring(0, 3)*/ await Authentication()
                  .getData()
                  .toString() ==
              "(0)") {
            AlertNotPNP(context);
          } else {
            await Authentication().createGuest(Entry(
                qr: barcode!.code.toString(),
                state: "Out",
                datetime: DateTime.now().toString()));
            CurrAuthentication().updateGuestCountMinus();
          }
        },
        child: const Text('OUT'),
      );*/
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('vehiclepop').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');
              //final data = docs[i].data();data['current'],
              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;

                final curr = docs.map((data) => data['current']).toList();
                return ElevatedButton(
                  child: Text("Exit"),
                  onPressed: () async {
                    if (barcode!.code.toString().substring(0, 3) == "pnp") {
                      if (/*barcode!.code.toString().substring(0, 3)*/ curr
                              .toString() ==
                          "[0]") {
                      } else {
                        await Authentication().createGuest(Entry(
                            qr: barcode!.code.toString(),
                            state: "Out",
                            datetime: DateTime.now().toString()));
                        CurrAuthentication().updateGuestCountMinus();
                      }
                    } else {}
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );
  void onQRViewCreated(QRViewController controller1) {
    setState(() => this.controller1 = controller1);
    controller1.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }

  Future onQRTextViewCreated(QRViewController controller) async {
    // ignore: await_only_futures
    await controller.scannedDataStream
        .listen((value) => setState(() => qrTextController.text = value));
  }

  Widget AlertNotPNP(BuildContext context) {
    return AlertDialog(
      title: new Text('Message'),
      content: Text('Your file is saved.'),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pop(); // dismisses only the dialog and returns nothing
          },
          child: new Text('OK'),
        ),
      ],
    );
  }
}
