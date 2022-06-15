import 'package:flutter/material.dart';
import '../../api/admin/api_admin_users.dart' as api_show;
import 'package:jwt_decode/jwt_decode.dart';
import '../../api/coms.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summit Running and Fitness"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: true,
      body: const UserPageScreen(),
    );
  }
}

class UserPageScreen extends StatefulWidget {
  const UserPageScreen({Key? key}) : super(key: key);

  @override
  _UserPageScreenState createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  late Future<List<String>> _districts;
  final String _errors = "";
  final Map<String, dynamic> payload = Jwt.parseJwt(Coms.token);
  Map<String, bool> _usersSelected = {};
  int? _sortIndex;
  bool _ascending = false;
  @override
  void initState() {
    super.initState();
    _districts = getDistricts();
  }

  Future<List<String>> getDistricts() async {
    List<String> users = await api_show.getAllUsers();
    for (var e in users) {
      _usersSelected[e.split(',')[0]] = false;
    }
    return users;
  }

  void onSort(int columnIndex, bool ascending) async {
    if (columnIndex == 0) {
      (await _districts).sort((e1, e2) {
        int result =
            compareString(ascending, e1.split(',')[0], e2.split(',')[0]);
        return result;
      });
    } else if (columnIndex == 1) {
      (await _districts).sort((e1, e2) {
        return compareString(ascending, e1.split(',')[1], e2.split(',')[1]);
      });
    }
    setState(() {
      _sortIndex = columnIndex;
      _ascending = ascending;
      //_districts = _districts;
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
                  "All Districts",
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
                          List<String> districts =
                              snapshot.data as List<String>;
                          List<String> names = [];
                          List<String> active = [];
                          for (int i = 0; i < districts.length; i++) {
                            List<String> district = districts[i].split(',');
                            names.add(district[0]);
                            active.add(district[1]);
                          }
                          TextStyle textStyle = TextStyle(
                            color: Colors.black87,
                            fontSize:
                                screenSize.width * screenSize.height * 0.00002 +
                                    8,
                          );
                          DataTable districtTable = DataTable(
                              sortAscending: _ascending,
                              sortColumnIndex: _sortIndex,
                              columns: <DataColumn>[
                                DataColumn(label: const Text('Name'), onSort: onSort),
                                DataColumn(
                                    label: const Text('Active'), onSort: onSort),
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
                                    DataCell(Text(
                                      names[index],
                                      style: textStyle,
                                    )),
                                    DataCell(Text(
                                      active[index],
                                      style: textStyle,
                                    )),
                                  ],
                                  selected: _usersSelected[names[index]]!,
                                  onSelectChanged: (bool? value) {
                                    setState(() {
                                      _usersSelected[names[index]] = value!;
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
                                  "Total Results: ${names.length}",
                                  style: textStyle,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: districtTable,
                              )
                            ],
                          );
                        } else {
                          return const LinearProgressIndicator();
                        }
                      }),
                      future: _districts),
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
                  for (var key in _usersSelected.keys) {
                    var value = _usersSelected[key];
                    if (value!) {
                      await api_show.changeState(key);
                    }
                    value = false;
                  }
                  setState(() {
                    _districts = getDistricts();
                    _usersSelected = _usersSelected;
                  });
                },
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.04,
              width: 10,
            ),
            SizedBox(
                width: screenSize.width * 0.9,
                child: Text(_errors,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'Pacifico'))),
          ],
        ));
  }
}
