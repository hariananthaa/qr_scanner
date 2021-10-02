import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qr_scanner',
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
  final controllerLink = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Scanner'),
      ),
      body: Center(
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
}
