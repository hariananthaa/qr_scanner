import 'package:flutter/material.dart';

Future<dynamic> resultLink(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  Text(
                    'PROFILE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Colors.pink,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      decorationColor: Colors.indigo,
                    ),
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {}),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                        //elevation: 5.0,
                        child: Text("Go"),
                      ),
                      TextButton(
                        onPressed: () {},
                        //elevation: 5.0,
                        child: Text("Go"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
