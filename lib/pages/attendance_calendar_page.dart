import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summit_app_2/pages/attendance_list_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../api/coms.dart' as coms;
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
  String _selectedDate = DateTime.now().toString();
  String _selectedDistrict = 'District';
  String _selectedType = "Type";
  String _errors = '';

  String getDistrict() {
    return _selectedDistrict;
  }

  String getDate() {
    return _selectedDate;
  }

  String getType() {
    return _selectedType;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value.toString().substring(0, 8);
    });
  }

  @override
  void initState() {
    super.initState();
    _districtList = getDistricts();
    _typeList = getTypes();
  }

  Future<List<String>> getDistricts() async {
    return await (districts.getDistricts());
  }

  Future<List<String>> getTypes() async {
    return await (types.getTypes());
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
              child: Text("Set Training Info",
                  style: GoogleFonts.josefinSans(
                    fontSize: screenSize.width * 0.07,
                  )),
            ),
            SizedBox(
              child: SfDateRangePicker(
                selectionColor: Colors.green,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: DateTime.now(),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                Row(
                  children: [
                    SizedBox(
                        height: screenSize.height * 0.06,
                        width: screenSize.width * 0.18,
                        child: FutureBuilder<List<String>>(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
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
                        )),
                    SizedBox(
                      width: screenSize.width * 0.03,
                    ),
                    SizedBox(
                        height: screenSize.height * 0.06,
                        width: screenSize.width * 0.18,
                        child: FutureBuilder<List<String>>(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
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
                        ))
                  ],
                ),
                SizedBox(
                  width: screenSize.width * 0.07,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        fixedSize: Size(
                            screenSize.width * 0.38, screenSize.height * 0.05)),
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
                          fontSize:
                              screenSize.width * screenSize.height * 0.00001 +
                                  10),
                    ))
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
