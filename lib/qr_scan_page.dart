import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qr Scanner',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Barcode? barcode;

  final controllerLink = TextEditingController();
  int currentIndex = 0;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller?.pauseCamera();
    }
    await controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => currentIndex = index),
        currentIndex: currentIndex,
        selectedFontSize: 22,
        unselectedFontSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR Code',
            //tooltip: 'Scan',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Create QR Code',
            //tooltip: 'Create',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      body: currentIndex == 0
          ? Stack(
              alignment: Alignment.center,
              children: <Widget>[
                buildQrView(context),
                Positioned(
                  top: 10,
                  child: buildControlButtons(),
                ),
                Positioned(
                  bottom: 10,
                  child: buildResult(),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(height: 50),
                  QrImage(
                    data: controllerLink.text,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 50),
                  buildTextField(link: 'Link', controller: controllerLink),
                  SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(
      {required String link, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter the Data',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
              suffixIcon: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.done, size: 25),
                onPressed: () => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).accentColor,
        borderWidth: 10,
        borderLength: 30,
        borderRadius: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.6,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }

  Widget buildResult() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            //alignment: Alignment.centerLeft,
            width: barcode != null
                ? MediaQuery.of(context).size.width * 0.7
                : MediaQuery.of(context).size.width * 0.4,
            child: Text(
              barcode != null ? '${barcode!.code}' : 'Scan a code!',
              maxLines: 1,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ),
          SizedBox(width: 5),
          barcode != null
              ? MaterialButton(
                  onPressed: () async {
                    print(barcode!.code);
                    final String url = barcode!.code;
                    if (barcode != null) {
                      print(barcode!.code);
                      launchUrl(url);
                    }
                  },
                  color: Colors.green,
                  child: Text(
                    "Go",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox(width: 1),
        ],
      ),
    );
  }

  Future launchUrl(String urlLink) async {
    if (await canLaunch(urlLink)) {
      launch(urlLink);
    }
  }

  Widget buildControlButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white24,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: FutureBuilder<bool?>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(
                      snapshot.data! ? Icons.flash_on : Icons.flash_off);
                } else {
                  return Container();
                }
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          ),
          IconButton(
            icon: FutureBuilder(
              future: controller?.getCameraInfo(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(Icons.switch_camera);
                } else {
                  return Container();
                }
              },
            ),
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
