import 'package:flutter/material.dart';
import 'package:summit_app_2/pages/menu_page.dart';
import '../api/api_login.dart' as api;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _userNameController =
      TextEditingController(text: '');
  late TextEditingController _passwordController =
      TextEditingController(text: '');
  bool _obsecureText = true;
  String _errors = "";
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const NetworkImage(
                "https://scontent.fhfa1-1.fna.fbcdn.net/v/t1.6435-9/57503541_2327721960582557_7710564158680334336_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=cdbe9c&_nc_ohc=dXp3zfqruXsAX_HQElb&_nc_ht=scontent.fhfa1-1.fna&oh=00_AT_JlY-XfxkVDzjDfjIgs2lHcxPmrSxm1w8OYyD_ij5gLg&oe=62BD0F03"),
            errorBuilder: (context, url, error) => const Icon(Icons.error),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.1),
                const Text('Login',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'Pacifico')),
                SizedBox(height: size.height * 0.1),
                TextFormField(
                  controller: _userNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "User name",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ),
                TextFormField(
                  obscureText: _obsecureText,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'Please enter valid password';
                    } else {
                      return null;
                    }
                  },
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white70),
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String password = _passwordController.text;
                    String userName = _userNameController.text;
                    String loggingErrors = await api.login(userName, password);
                    if (loggingErrors == "") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Menu()),
                      );
                    } else {
                      setState(() {
                        _errors = loggingErrors;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black.withOpacity(0.15),
                      fixedSize: const Size(200, 40)),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(_errors,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'Pacifico'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
