import 'package:flutter/material.dart';
import 'package:summit_app_2/api/coms.dart';
import '../api/api_attendance_list.dart' as api;
import 'menu_page.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AttendanceResult extends StatefulWidget {
  const AttendanceResult(
      {Key? key,
      required this.date,
      required this.district,
      required this.type})
      : super(key: key);
  final String district;
  final String type;
  final String date;

  @override
  State<AttendanceResult> createState() => _AttendanceResultState();
}

class _AttendanceResultState extends State<AttendanceResult> {
  late Future<List<String>>? _attendance;
  final Map<String, dynamic> payload = Jwt.parseJwt(Coms.token);
  @override
  void initState() {
    super.initState();
    String district = widget.district;
    String date = widget.date;
    String type = widget.type;
    _attendance = getAttendance(district, type, date);
  }

  Future<List<String>> getAttendance(
      String district, String type, String date) async {
    return await (api.getAttendance(district, date, type));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Summit Running and Fitness"),
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    fixedSize: Size(
                        screenSize.width * 0.38, screenSize.height * 0.05)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Menu()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                      fontSize:
                          screenSize.width * screenSize.height * 0.00001 + 10),
                )),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "The Attendance",
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
                      List<String> names = snapshot.data as List<String>;
                      DataTable usersTable = DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text("Number")),
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
                                DataCell(Text("${index + 1}")),
                                DataCell(Text(names[index])),
                              ],
                            ),
                          ));
                      return usersTable;
                    } else {
                      return const LinearProgressIndicator();
                    }
                  }),
                  future: _attendance),
            ),
          ],
        ),
      ),
    );
  }
}
