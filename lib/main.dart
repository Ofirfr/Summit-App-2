import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'api/api_training_type.dart' as types;

void main() {
  runApp(const SummitApp2());
}

class SummitApp2 extends StatelessWidget {
  const SummitApp2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Login(),
    );
  }
}
