import 'package:flutter/material.dart';
import '../../api/api_admin_add.dart' as api_add;
import '../../api/api_district.dart' as api_show;
import 'package:jwt_decode/jwt_decode.dart';
import '../../api/coms.dart';

class DistrictPage extends StatelessWidget {
  const DistrictPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summit Running and Fitness"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: true,
      body: const DistrictPageScreen(),
    );
  }
}

class DistrictPageScreen extends StatefulWidget {
  const DistrictPageScreen({Key? key}) : super(key: key);

  @override
  _DistrictPageScreenState createState() => _DistrictPageScreenState();
}

class _DistrictPageScreenState extends State<DistrictPageScreen> {
  TextEditingController districtNameController = TextEditingController();
  late Future<List<String>> _districts;
  String _errors = "";
  final Map<String, dynamic> payload = Jwt.parseJwt(Coms.token);
  Map<String, bool> _districtsSelected = {};
  int? _sortIndex;
  bool _ascending = false;
  @override
  void initState() {
    super.initState();
    _districts = getDistricts();
  }

  Future<List<String>> getDistricts() async {
    List<String> districts = await api_show.getAllDistricts();
    for (var e in districts) {
      _districtsSelected[e.split(',')[0]] = false;
    }
    return districts;
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
                                DataColumn(label: Text('Name'), onSort: onSort),
                                DataColumn(
                                    label: Text('Active'), onSort: onSort),
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
                                  selected: _districtsSelected[names[index]]!,
                                  onSelectChanged: (bool? value) {
                                    setState(() {
                                      _districtsSelected[names[index]] = value!;
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
                  for (var key in _districtsSelected.keys) {
                    var value = _districtsSelected[key];
                    if (value!) {
                      await api_show.changeState(key);
                    }
                    value = false;
                  }
                  setState(() {
                    _districts = getDistricts();
                    _districtsSelected = _districtsSelected;
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
                  "Add District",
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
                          child: const Text("District Name")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: districtNameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "District Name",
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
                          String districtName = (districtNameController.text);
                          String result =
                              await api_add.addDistrict(districtName);
                          if (result == "District added succesfully") {
                            setState(() {
                              _districts = getDistricts();
                              _errors = '';
                              districtNameController.clear();
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
