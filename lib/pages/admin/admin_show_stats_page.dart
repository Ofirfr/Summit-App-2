import 'package:flutter/material.dart';
import 'package:summit_app_2/api/coms.dart';
import '../../api/api_admin_stats.dart' as stats;
import 'package:jwt_decode/jwt_decode.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class StatsResult extends StatefulWidget {
  const StatsResult(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.district,
      required this.type,
      required this.coach})
      : super(key: key);
  final String district;
  final String type;
  final String startDate;
  final String endDate;
  final String coach;

  @override
  State<StatsResult> createState() => _StatsResultState();
}

class _StatsResultState extends State<StatsResult> {
  late Future<List<dynamic>>? _stats;
  final Map<String, dynamic> payload = Jwt.parseJwt(Coms.token);
  int? _sortIndex;
  bool _ascending = false;
  @override
  void initState() {
    super.initState();
    String district = widget.district;
    String startDate = widget.startDate;
    String endDate = widget.endDate;
    String type = widget.type;
    String coach = widget.coach;
    _stats = getAttendance(district, type, coach, startDate, endDate);
  }

  Future<List<dynamic>> getAttendance(String district, String type,
      String coach, String startDate, String endDate) async {
    return (await (stats.statsByParams(
        coach, type, district, startDate, endDate)));
  }

  void onSort(int columnIndex, bool ascending) async {
    if (columnIndex == 0) {
      (await _stats)?.sort((e1, e2) {
        DateTime date1 = DateTime.parse(e1["date"]);
        DateTime date2 = DateTime.parse(e2["date"]);
        if (ascending) {
          return date1.compareTo(date2) * -1;
        } else {
          return date1.compareTo(date2);
        }
      });
    } else if (columnIndex == 1) {
      (await _stats)?.sort((e1, e2) => compareString(
          ascending, e1["coach"]["coachName"], e2["coach"]["coachName"]));
    } else if (columnIndex == 2) {
      (await _stats)?.sort((e1, e2) => compareString(
          ascending, e1["district"]["name"], e2["district"]["name"]));
    } else if (columnIndex == 3) {
      (await _stats)?.sort((e1, e2) =>
          compareString(ascending, e1["type"]["type"], e2["type"]["type"]));
    } else if (columnIndex == 4) {
      (await _stats)?.sort((e1, e2) {
        if (ascending) {
          return e1["users"].length - e2["users"].length;
        } else {
          return e2["users"].length - e1["users"].length;
        }
      });
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
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Summit Running and Fitness"),
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
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
                  "Results",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            Row(children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: FutureBuilder(
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> result =
                                  (snapshot.data) as List<dynamic>;
                              List<String> dates = [];
                              List<String> coaches = [];
                              List<String> types = [];
                              List<String> districts = [];
                              List<String> users = [];
                              double maxUsers = 0;
                              for (var element in result) {
                                String date = DateFormat("dd/MM/yyyy")
                                    .format(DateTime.parse(element["date"]));

                                String coach = element["coach"]["coachName"];

                                String type = element["type"]["type"];

                                String district = element["district"]["name"];

                                String usersString = "";
                                List<dynamic> userList = element["users"];
                                double count = 0;
                                for (var user in userList) {
                                  count++;
                                  usersString += "${count.round().toString()}. "
                                      "${user["userName"]}\n";
                                }
                                if (count > maxUsers) {
                                  maxUsers = count;
                                }
                                usersString = usersString.trim();
                                users.add(usersString);
                                dates.add(date);
                                coaches.add(coach);
                                types.add(type);
                                districts.add(district);
                              }

                              TextStyle textStyle = TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width *
                                          screenSize.height *
                                          0.000005 +
                                      8,
                                  fontWeight: FontWeight.bold);
                              if (users.isEmpty) {
                                return Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No data",
                                      style: textStyle,
                                    ));
                              }
                              DataTable statsTable = DataTable(
                                  sortAscending: _ascending,
                                  sortColumnIndex: _sortIndex,
                                  columnSpacing: 3,
                                  columns: <DataColumn>[
                                    DataColumn(
                                        label: Text(
                                          'Date',
                                          style: textStyle,
                                        ),
                                        onSort: onSort),
                                    DataColumn(
                                        label: Text('Coach', style: textStyle),
                                        onSort: onSort),
                                    DataColumn(
                                        label:
                                            Text('District', style: textStyle),
                                        onSort: onSort),
                                    DataColumn(
                                        label: Text('Type', style: textStyle),
                                        onSort: onSort),
                                    DataColumn(
                                        label: Text(
                                          'Users',
                                          style: textStyle,
                                        ),
                                        onSort: onSort),
                                  ],
                                  dataRowHeight: maxUsers * 30,
                                  rows: List<DataRow>.generate(
                                    dates.length,
                                    (int index) => DataRow(
                                      color: MaterialStateProperty.resolveWith<
                                          Color?>((Set<MaterialState> states) {
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
                                        DataCell(Text(dates[index],
                                            style: textStyle)),
                                        DataCell(Text(coaches[index],
                                            style: textStyle)),
                                        DataCell(Text(districts[index],
                                            style: textStyle)),
                                        DataCell(Text(types[index],
                                            style: textStyle)),
                                        DataCell(Text(users[index],
                                            style: textStyle)),
                                      ],
                                    ),
                                  ));
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Total Results: ${dates.length}",
                                      style: textStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: statsTable,
                                  )
                                ],
                              );
                            } else {
                              return const LinearProgressIndicator();
                            }
                          }),
                          future: _stats)))
            ]),
          ],
        ),
      ),
    );
  }
}
