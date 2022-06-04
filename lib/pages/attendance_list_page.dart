// Make 2 lists, each sorted by abc of name:
// first list is for the district of the training, will contain users within the district
// second list if for all other users, that dont apply to that district

// Optional: get attendance of training and mark them

// Send to server all marked users as attendance
import 'package:flutter/material.dart';
import 'package:summit_app_2/pages/attendance_show_list.dart';
import '../api/api_attendance_list.dart' as api;

class AttendanceList extends StatefulWidget {
  const AttendanceList(
      {Key? key,
      required this.date,
      required this.district,
      required this.type})
      : super(key: key);
  final String district;
  final String type;
  final String date;

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  late Future<Map<String, bool>> _districtUsers;
  late Future<Map<String, bool>> _otherDistrictUsers;
  @override
  void initState() {
    super.initState();
    String district = widget.district;
    _districtUsers = getDistrictUsers(district);
    _otherDistrictUsers = getOtherDistrictsUsers(district);
  }

  Future<Map<String, bool>> getDistrictUsers(String district) async {
    List<String> users = await (api.getDistrictUsers(district));
    List<bool> selected =
        List<bool>.generate(users.length, (int index) => false);
    Map<String, bool> usersSelected = new Map();
    for (var i = 0; i < users.length; i++) {
      usersSelected[users[i]] = selected[i];
    }
    return usersSelected;
  }

  Future<Map<String, bool>> getOtherDistrictsUsers(String district) async {
    List<String> users = await (api.getOtherDistrictsUsers(district));
    List<bool> selected =
        List<bool>.generate(users.length, (int index) => false);
    Map<String, bool> usersSelected = new Map();
    for (var i = 0; i < users.length; i++) {
      usersSelected[users[i]] = selected[i];
    }
    return usersSelected;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Summit Running and Fitness"),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: FutureBuilder(
                builder: ((context, snapshot) {
                  return GestureDetector(
                    onTap: () async {
                      List<String> attendance = [];
                      List<dynamic> maps = snapshot.data as List<dynamic>;
                      for (var map in maps) {
                        map = map as Map<String, bool>;
                        map.forEach((key, value) {
                          if (value == true) {
                            attendance.add(key);
                          }
                        });
                      }
                      List<String> result = await api.sendAttendance(attendance,
                          widget.date, widget.type, widget.district);
                      if (result[0] == "Marked users as attendance") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendanceResult(
                                  date: widget.date,
                                  district: widget.district,
                                  type: widget.type)),
                        );
                      }
                    },
                    child: const Icon(
                      Icons.upload_file_outlined,
                      size: 26.0,
                    ),
                  );
                }),
                future: Future.wait([_districtUsers, _otherDistrictUsers]),
              ))
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        //padding: const EdgeInsets.all(20),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  widget.district,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              width: screenSize.width * 0.7,
              child: FutureBuilder(
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, bool> usersSelected =
                          snapshot.data as Map<String, bool>;
                      List<String> names =
                          List<String>.from(usersSelected.keys);
                      DataTable usersTable = DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Name'),
                            ),
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
                              cells: <DataCell>[DataCell(Text(names[index]))],
                              selected: usersSelected[names[index]]!,
                              onSelectChanged: (bool? value) {
                                setState(() {
                                  usersSelected[names[index]] = value!;
                                });
                              },
                            ),
                          ));
                      return usersTable;
                    } else {
                      return const LinearProgressIndicator();
                    }
                  }),
                  future: _districtUsers),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "All other districts",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              width: screenSize.width * 0.7,
              child: FutureBuilder(
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, bool> usersSelected =
                          snapshot.data as Map<String, bool>;
                      List<String> names =
                          List<String>.from(usersSelected.keys);
                      DataTable usersTable = DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Name'),
                            ),
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
                                DataCell(
                                  Text(
                                    names[index],
                                  ),
                                )
                              ],
                              selected: usersSelected[names[index]]!,
                              onSelectChanged: (bool? value) {
                                setState(() {
                                  usersSelected[names[index]] = value!;
                                });
                              },
                            ),
                          ));
                      return usersTable;
                    } else {
                      return const LinearProgressIndicator();
                    }
                  }),
                  future: _otherDistrictUsers),
            ),
          ],
        ),
      ),
    );
  }
}
