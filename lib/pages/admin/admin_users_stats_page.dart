import 'package:flutter/material.dart';
import 'package:summit_app_2/pages/admin/admin_show_users_stats_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../api/api_district.dart' as districts;
import "../../api/admin/api_admin_users.dart" as users;

class UsersStatsPage extends StatefulWidget {
  const UsersStatsPage({Key? key}) : super(key: key);

  @override
  UsersStatsPageState createState() => UsersStatsPageState();
}

class UsersStatsPageState extends State<UsersStatsPage> {
  late Future<List<String>> _districtList;
  late Future<List<String>> _usersList;

  // String _selectedDate =
  //     DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  String _range =
      "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}";
  String _selectedDistrict = 'Any';
  String _selectedUser = 'Any';
  final TextEditingController _biggestCount = TextEditingController(text: "0");
  String _errors = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _districtList = getDistricts();
    _usersList = getUsers();
  }

  Future<List<String>> getDistricts() async {
    List<String> result = await (districts.getAllDistricts());
    List<String> names = [];
    for (var district in result) {
      names.add(district.split(',')[0]);
    }
    return names;
  }

  Future<List<String>> getUsers() async {
    List<String> result = await (users.getAllUsers());
    List<String> names = [];
    for (var coach in result) {
      names.add(coach.split(',')[0]);
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Summit Running and Fitness'),
        ),
        body: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: Container(
                      color: Colors.white,
                      width: screenSize.width,
                      alignment: Alignment.center,
                      child: const Image(
                          fit: BoxFit.cover,
                          width: 100,
                          image:
                              AssetImage("assets/images/summit_big_logo.png"))),
                )),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            Center(
              child: Text("Choose filters",
                  style: TextStyle(
                      fontSize: screenSize.width * 0.07,
                      fontFamily: "Pacifico")),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                SizedBox(
                  width: screenSize.width * 0.5,
                  child: Text("Selected Range:\n$_range",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize:
                              screenSize.width * screenSize.height * 0.00001 +
                                  10,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  child: ElevatedButton(
                    child: Text(
                      "Change Range",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize:
                              screenSize.width * screenSize.height * 0.00001 +
                                  10),
                    ),
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Change Range'),
                              content: SingleChildScrollView(
                                  reverse: true,
                                  child: SizedBox(
                                    width: screenSize.width * 0.2,
                                    child: SfDateRangePicker(
                                      selectionColor: Colors.green,
                                      onSelectionChanged: _onSelectionChanged,
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                    ),
                                  )),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.1,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.15,
                        child: Text("District:"),
                      ),
                      SizedBox(
                          height: screenSize.height * 0.06,
                          width: screenSize.width * 0.36,
                          child: FutureBuilder<List<String>>(
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton<String>(
                                  isExpanded: true,
                                  icon: const Icon(Icons.import_export_sharp),
                                  hint: Text(
                                    "Any",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: screenSize.width *
                                                screenSize.height *
                                                0.00001 +
                                            10),
                                  ),
                                  value: _selectedDistrict == "Any"
                                      ? null
                                      : _selectedDistrict,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.width *
                                              screenSize.height *
                                              0.00001 +
                                          10),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.green,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedDistrict = newValue!;
                                      _errors = '';
                                    });
                                  },
                                  items: snapshot.data!
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return const LinearProgressIndicator();
                              }
                            },
                            future: _districtList,
                          ))
                    ]),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.15,
                      child: Text("User:"),
                    ),
                    SizedBox(
                        height: screenSize.height * 0.06,
                        width: screenSize.width * 0.36,
                        child: FutureBuilder<List<String>>(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
                                alignment: Alignment.centerLeft,
                                isExpanded: true,
                                icon: const Icon(Icons.import_export_sharp),
                                hint: Text(
                                  "Any",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.width *
                                              screenSize.height *
                                              0.00001 +
                                          10),
                                ),
                                value: _selectedUser == "Any"
                                    ? null
                                    : _selectedUser,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenSize.width *
                                            screenSize.height *
                                            0.00001 +
                                        10),
                                underline: Container(
                                  height: 2,
                                  color: Colors.green,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedUser = newValue!;
                                    _errors = '';
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            } else {
                              return const LinearProgressIndicator();
                            }
                          },
                          future: _usersList,
                        )),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.15,
                      child: Text("Max Count:"),
                    ),
                    SizedBox(
                        height: screenSize.height * 0.06,
                        width: screenSize.width * 0.36,
                        child: TextFormField(
                          controller: _biggestCount,
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    fixedSize: Size(
                        screenSize.width * 0.38, screenSize.height * 0.05)),
                onPressed: () async {
                  List<String> range = (_range.split('-'));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserStatsResult(
                                biggestCount: int.parse(
                                  _biggestCount.text,
                                ),
                                user: _selectedUser,
                                startDate: range[0],
                                endDate: range[1],
                                district: _selectedDistrict,
                              )));
                },
                child: Text(
                  "View Stats",
                  style: TextStyle(
                      fontSize:
                          screenSize.width * screenSize.height * 0.00001 + 10),
                )),
            Text(_errors,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontFamily: 'Pacifico'))
          ],
        ));
  }
}
