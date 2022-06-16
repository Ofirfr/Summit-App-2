import 'package:flutter/material.dart';
import 'api/Coms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/menu_page.dart';
import 'api/api_login.dart' as api;

void main() {
  runApp(const SummitApp2());
}

class SummitApp2 extends StatefulWidget {
  const SummitApp2({Key? key}) : super(key: key);

  @override
  State<SummitApp2> createState() => _SummitApp2State();
}

class _SummitApp2State extends State<SummitApp2> {
  late Future<Widget> nextPage;
  Future<Widget> loadToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String tokenValid =
          await api.loginWithToken(token != null ? token.toString() : "");
      if (tokenValid == "OK") {
        return const Menu();
      } else {
        return const Login();
      }
      // ignore: empty_catches
    } catch (e) {
      return const Login();
    }
  }

  @override
  void initState() {
    super.initState();
    nextPage = loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: nextPage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data as Widget;
          } else {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Please Wait For The Application, Loading...',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const CircularProgressIndicator(
                      semanticsLabel: 'Please Wait',
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
