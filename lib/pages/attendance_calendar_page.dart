import 'package:flutter/material.dart';
import 'package:summit_app_2/pages/attendance_list_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../api/api_district.dart' as districts;
import '../api/api_training_type.dart' as types;

class AttendanceCalendarPage extends StatefulWidget {
  const AttendanceCalendarPage({Key? key}) : super(key: key);

  @override
  AttendanceCalendarPageState createState() => AttendanceCalendarPageState();
}

class AttendanceCalendarPageState extends State<AttendanceCalendarPage> {
  late Future<List<String>> _districtList;
  late Future<List<String>> _typeList;
  String _selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String _selectedDistrict = 'District';
  String _selectedType = "Type";
  String _errors = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = DateFormat('dd/MM/yyyy').format(args.value);
    });
  }

  @override
  void initState() {
    super.initState();
    _districtList = getDistricts();
    _typeList = getTypes();
  }

  Future<List<String>> getDistricts() async {
    return await (districts.getActiveDistricts());
  }

  Future<List<String>> getTypes() async {
    return await (types.getActiveTypes());
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
          mainAxisSize: MainAxisSize.min,
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
              child: Text("Set Training Info",
                  style: TextStyle(
                      fontSize: screenSize.width * 0.07,
                      fontFamily: "Pacifico")),
            ),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                SizedBox(
                  width: screenSize.width * 0.5,
                  child: Text("Selected Date:\n$_selectedDate",
                      style: TextStyle(
                          //fontFamily: "Pacifico",
                          color: Colors.black87,
                          fontSize:
                              screenSize.width * screenSize.height * 0.00001 +
                                  10,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  width: screenSize.width * 0.35,
                  child: ElevatedButton(
                    child: Text(
                      "Change Date",
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
                                          DateRangePickerSelectionMode.single,
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
              height: screenSize.height * 0.05,
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
                        child: Text(
                          "District:",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenSize.width *
                                      screenSize.height *
                                      0.00001 +
                                  10),
                        ),
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
                                    "District",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: screenSize.width *
                                                screenSize.height *
                                                0.00001 +
                                            10),
                                  ),
                                  value: _selectedDistrict == "District"
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
                      child: Text(
                        "Type:",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize:
                                screenSize.width * screenSize.height * 0.00001 +
                                    10),
                      ),
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
                                  "Type",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.width *
                                              screenSize.height *
                                              0.00001 +
                                          10),
                                ),
                                value: _selectedType == "Type"
                                    ? null
                                    : _selectedType,
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
                                    _selectedType = newValue!;
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
                          future: _typeList,
                        )),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.3,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.4,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            if (_selectedDistrict == "District") {
                              setState(() {
                                _errors += 'Please select District\n';
                              });
                              return;
                            }
                            if (_selectedType == "Type") {
                              setState(() {
                                _errors += 'Please select Type\n';
                              });
                              return;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AttendanceList(
                                          date: _selectedDate,
                                          district: _selectedDistrict,
                                          type: _selectedType,
                                        )));
                          },
                          child: Text(
                            "Check attendance",
                            style: TextStyle(
                                fontSize: screenSize.width *
                                        screenSize.height *
                                        0.00001 +
                                    10,
                                color: Colors.black87),
                          )),
                    ),
                  ],
                ),
              ],
            ),
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
