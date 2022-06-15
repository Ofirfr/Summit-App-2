import 'package:flutter/material.dart';
import 'package:summit_app_2/api/coms.dart';
import '../../api/admin/api_admin_stats.dart' as stats;
import 'package:jwt_decode/jwt_decode.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import "../../excel/excelGenerator.dart" as excel;

class UserStatsResult extends StatefulWidget {
  const UserStatsResult(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.district,
      required this.user,
      required this.biggestCount})
      : super(key: key);
  final String district;
  final String startDate;
  final String endDate;
  final String user;
  final int biggestCount;

  @override
  State<UserStatsResult> createState() => _UserStatsResultState();
}

class _UserStatsResultState extends State<UserStatsResult> {
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
    String user = widget.user;
    _stats = getStats(district, user, startDate, endDate);
  }

  Future<List<dynamic>> getStats(
      String district, String user, String startDate, String endDate) async {
    return (await (stats.statsByUsers(user, district, startDate, endDate)));
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
                              List<String> districts = [];
                              List<String> users = [];
                              List<int> counts = [];
                              double maxTrainings = 0;
                              for (var element in result) {
                                int trainingsCount =
                                    element["_count"]["trainings"];
                                if (trainingsCount > widget.biggestCount &&
                                    widget.biggestCount != 0) {
                                  continue;
                                }
                                String user = element["userName"];

                                String district =
                                    element["mainDistrict"]["name"];

                                if (trainingsCount > maxTrainings) {
                                  maxTrainings = trainingsCount.toDouble();
                                }

                                String datesString = "";
                                List<dynamic> dateList = element["trainings"];

                                dateList.sort((e1, e2) {
                                  DateTime date1 = DateTime.parse(e1["date"]);
                                  DateTime date2 = DateTime.parse(e2["date"]);
                                  return date1.compareTo(date2);
                                });

                                for (var element in dateList) {
                                  datesString +=
                                      "${DateFormat("dd/MM/yyyy").format(DateTime.parse(element["date"]))}\n";
                                }
                                datesString = datesString.trim();
                                users.add(user);
                                dates.add(datesString);
                                districts.add(district);
                                counts.add(trainingsCount);
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
                                  columnSpacing: 10,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'User',
                                        style: textStyle,
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text('District', style: textStyle),
                                    ),
                                    DataColumn(
                                      label: Text('Training Count',
                                          style: textStyle),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Dates',
                                        style: textStyle,
                                      ),
                                    ),
                                  ],
                                  dataRowHeight: maxTrainings * 20,
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
                                        DataCell(Text(users[index],
                                            style: textStyle)),
                                        DataCell(Text(districts[index],
                                            style: textStyle)),
                                        DataCell(Text(counts[index].toString(),
                                            style: textStyle)),
                                        DataCell(Text(dates[index],
                                            style: textStyle)),
                                      ],
                                    ),
                                  ));
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenSize.width * 0.1,
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "Total Results: ${dates.length}",
                                          style: textStyle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenSize.width * 0.3,
                                      ),
                                      SizedBox(
                                          child: ElevatedButton(
                                        onPressed: () async {
                                          String fileName =
                                              "${widget.startDate.trim().replaceAll('/', '-')}_to_${widget.endDate.trim().replaceAll('/', '-')}_report";
                                          await excel.generateExcel(
                                              fileName, statsTable);
                                        },
                                        child: Text("Export To Excel"),
                                      )),
                                    ],
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
