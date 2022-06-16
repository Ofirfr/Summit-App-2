import 'package:flutter/material.dart';
import '../api/api_add_member.dart' as api;
import 'menu_page.dart';

class AddMemberPage extends StatelessWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summit Running and Fitness"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: true,
      body: const AddMemberScreen(),
    );
  }
}

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  String _errors = "";
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: const Image(
                          fit: BoxFit.cover,
                          width: 100,
                          image:
                              AssetImage("assets/images/summit_big_logo.png"))),
                )),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Add Member",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              height: screenSize.height * 0.04,
              width: 10,
            ),
            SizedBox(
              width: screenSize.width * 0.9,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          child: const Text("Full Name")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: fullNameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Full Name",
                                contentPadding: EdgeInsets.all(20)),
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          )),
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          child: const Text("Email")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                contentPadding: EdgeInsets.all(20)),
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          )),
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          child: const Text("Phone Number")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: phoneController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone Number",
                                contentPadding: EdgeInsets.all(20)),
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          )),
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          child: const Text("District")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: districtController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "District",
                                contentPadding: EdgeInsets.all(20)),
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          )),
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Container(
                    width: 570,
                    height: 100,
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                        onPressed: () async {
                          String userName = (fullNameController.text);
                          String email = (emailController.text);
                          String phoneNumber = (phoneController.text);
                          String district = (districtController.text);
                          String result = await api.addMember(
                              userName, email, phoneNumber, district);
                          if (result == "User $userName added.") {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Menu()),
                                (Route<dynamic> route) => false);
                          } else {
                            setState(() {
                              _errors = result;
                            });
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        )),
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
        ));
  }
}
