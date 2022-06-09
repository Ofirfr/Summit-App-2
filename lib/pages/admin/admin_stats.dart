import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summit_app_2/pages/attendance_list_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../api/coms.dart' as coms;
import '../../api/api_district.dart' as districts;
import '../../api/api_training_type.dart' as types;

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({Key? key}) : super(key: key);

  @override
  AdminStatsPageState createState() => AdminStatsPageState();
}

class AdminStatsPageState extends State<AdminStatsPage> {
  late Future<List<String>> _districtList;
  late Future<List<String>> _typeList;
  String _selectedDate =
      DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  String _range =
      "${DateFormat('dd-MM-yyyy').format(DateTime.now())} - ${DateFormat('dd-MM-yyyy').format(DateTime.now())}";
  String _selectedDistrict = 'Any';
  String _selectedType = "Any";
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
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      }
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
              child: Text("Choose filters",
                  style: GoogleFonts.josefinSans(
                    fontSize: screenSize.width * 0.07,
                  )),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                SizedBox(
                  width: screenSize.width * 0.3,
                  child: Text(
                    "Selected Range: $_range",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize:
                            screenSize.width * screenSize.height * 0.00001 +
                                10),
                  ),
                ),
                SizedBox(
                  child: TextButton(
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
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.13,
                      child: Text("District:"),
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
                        )),
                    SizedBox(
                      width: screenSize.width * 0.13,
                      child: Text("Type:"),
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
                                  "Any",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.width *
                                              screenSize.height *
                                              0.00001 +
                                          10),
                                ),
                                value: _selectedType == "Any"
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
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    fixedSize: Size(
                        screenSize.width * 0.38, screenSize.height * 0.05)),
                onPressed: () {},
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
