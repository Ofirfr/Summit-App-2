import 'package:flutter/material.dart';
import '../../api/api_admin_add.dart' as api_add;
import '../../api/api_coaches.dart' as api_show;
import 'package:jwt_decode/jwt_decode.dart';
import '../../api/coms.dart';

class CoachPage extends StatelessWidget {
  const CoachPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summit Running and Fitness"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: true,
      body: const CoachPageScreen(),
    );
  }
}

class CoachPageScreen extends StatefulWidget {
  const CoachPageScreen({Key? key}) : super(key: key);

  @override
  _CoachPageScreenState createState() => _CoachPageScreenState();
}

class _CoachPageScreenState extends State<CoachPageScreen> {
  TextEditingController coacheNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isAdminBox = false;
  late Future<List<String>> _coaches;
  String _errors = "";
  final Map<String, dynamic> payload = Jwt.parseJwt(Coms.token);

  @override
  void initState() {
    super.initState();
    _coaches = getCoaches();
  }

  Future<List<String>> getCoaches() async {
    List<String> coaches = await api_show.getCoaches();
    return coaches;
  }

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
                  "All Coaches",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              width: screenSize.width * 0.7,
              child: FutureBuilder(
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> coaches = snapshot.data as List<String>;
                      List<String> names = [];
                      List<String> isAdmin = [];
                      for (var e in coaches) {
                        List<String> coach = e.split(',');
                        names.add(coach[0]);
                        isAdmin.add(coach[1]);
                      }
                      DataTable districtTable = DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text("Number")),
                            DataColumn(
                              label: Text('Name'),
                            ),
                            DataColumn(label: Text("Admin"))
                          ],
                          rows: List<DataRow>.generate(
                            names.length,
                            (int index) => DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                // All rows will have the same selected color.
                                if (states.contains(MaterialState.selected)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08);
                                }
                                // Even rows will have a grey color.
                                if (index.isEven) {
                                  return Colors.grey.withOpacity(0.3);
                                }
                                return null; // Use default value for other states and odd rows.
                              }),
                              cells: <DataCell>[
                                DataCell(Text("${index + 1}")),
                                DataCell(Text(names[index])),
                                DataCell(Text(isAdmin[index]))
                              ],
                            ),
                          ));
                      return districtTable;
                    } else {
                      return const LinearProgressIndicator();
                    }
                  }),
                  future: _coaches),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Add Coach",
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
                          child: const Text("Coach Name")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: coacheNameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Coach Name",
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
                          child: const Text("Password")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: passwordController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
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
                          child: const Text("Is admin")),
                      SizedBox(
                          child: Checkbox(
                        value: isAdminBox,
                        onChanged: (value) {
                          setState(() {
                            isAdminBox = value!;
                          });
                        },
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
                          String coachName = (coacheNameController.text);
                          String password = (passwordController.text);
                          String result = await api_add.addCoach(
                              coachName, password, isAdminBox);
                          if (result == "Coach $coachName added.") {
                            setState(() {
                              _coaches = getCoaches();
                              _errors = '';
                              coacheNameController.clear();
                              passwordController.clear();
                              isAdminBox = false;
                            });
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
