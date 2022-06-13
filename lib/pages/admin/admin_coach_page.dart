import 'package:flutter/material.dart';
import '../../api/admin/api_admin_add.dart' as api_add;
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
  Map<String, bool> _coachesSelected = {};
  int? _sortIndex;
  bool _ascending = false;
  @override
  void initState() {
    super.initState();
    _coaches = getCoaches();
  }

  Future<List<String>> getCoaches() async {
    List<String> coaches = await api_show.getAllCoaches();
    for (var e in coaches) {
      _coachesSelected[e.split(',')[0]] = false;
    }
    return coaches;
  }

  void onSort(int columnIndex, bool ascending) async {
    if (columnIndex == 0) {
      (await _coaches).sort((e1, e2) =>
          compareString(ascending, e1.split(',')[0], e2.split(',')[0]));
    } else if (columnIndex == 1) {
      (await _coaches).sort((e1, e2) =>
          compareString(ascending, e1.split(',')[1], e2.split(',')[1]));
    } else if (columnIndex == 2) {
      (await _coaches).sort((e1, e2) =>
          compareString(ascending, e1.split(',')[2], e2.split(',')[2]));
    }
    setState(() {
      _sortIndex = columnIndex;
      _ascending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) => ascending
      ? value1.toLowerCase().compareTo(value2.toLowerCase())
      : value2.toLowerCase().compareTo(value1.toLowerCase());
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        reverse: false,
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
            Row(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: FutureBuilder(
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> coaches = snapshot.data as List<String>;
                          List<String> names = [];
                          List<String> isAdmin = [];
                          List<String> active = [];
                          for (var e in coaches) {
                            List<String> coach = e.split(',');
                            names.add(coach[0]);
                            isAdmin.add(coach[1]);
                            active.add(coach[2]);
                          }
                          TextStyle textStyle = TextStyle(
                            color: Colors.black87,
                            fontSize:
                                screenSize.width * screenSize.height * 0.00002 +
                                    8,
                          );
                          DataTable coachesTable = DataTable(
                              sortAscending: _ascending,
                              sortColumnIndex: _sortIndex,
                              columnSpacing: 3,
                              columns: <DataColumn>[
                                DataColumn(
                                    label: Text(
                                      'Name',
                                    ),
                                    onSort: onSort),
                                DataColumn(
                                    label: Text(
                                      "Admin",
                                    ),
                                    onSort: onSort),
                                DataColumn(
                                    label: Text(
                                      "Active",
                                    ),
                                    onSort: onSort)
                              ],
                              dataRowHeight: screenSize.height * 0.08,
                              rows: List<DataRow>.generate(
                                names.length,
                                (int index) => DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    // All rows will have the same selected color.
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.08);
                                    }
                                    // Even rows will have a grey color.
                                    if (index.isEven) {
                                      return Colors.black.withOpacity(0.1);
                                    }

                                    return null; // Use default value for other states and odd rows.
                                  }),
                                  cells: <DataCell>[
                                    DataCell(
                                        Text(names[index], style: textStyle)),
                                    DataCell(
                                        Text(isAdmin[index], style: textStyle)),
                                    DataCell(
                                        Text(active[index], style: textStyle)),
                                  ],
                                  selected: _coachesSelected[names[index]]!,
                                  onSelectChanged: (bool? value) {
                                    setState(() {
                                      _coachesSelected[names[index]] = value!;
                                    });
                                  },
                                ),
                              ));
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Total Results: ${coaches.length}",
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: coachesTable,
                              )
                            ],
                          );
                        } else {
                          return const LinearProgressIndicator();
                        }
                      }),
                      future: _coaches),
                ))
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.02,
              width: 10,
            ),
            Align(
              child: ElevatedButton(
                child: const Text("Change State Of Selected"),
                onPressed: () async {
                  for (var key in _coachesSelected.keys) {
                    var value = _coachesSelected[key];
                    if (value!) {
                      await api_show.changeState(key);
                    }
                    value = false;
                  }
                  setState(() {
                    _coaches = getCoaches();
                    _coachesSelected = _coachesSelected;
                  });
                },
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.04,
              width: 10,
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
