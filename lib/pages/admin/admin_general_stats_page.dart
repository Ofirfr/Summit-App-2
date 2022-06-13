import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../api/api_district.dart' as districts;
import '../../api/api_training_type.dart' as types;
import "../../api/api_coaches.dart" as coaches;
import 'admin_show_general_stats_page.dart';

class GeneralStatsPage extends StatefulWidget {
  const GeneralStatsPage({Key? key}) : super(key: key);

  @override
  GeneralStatsPageState createState() => GeneralStatsPageState();
}

class GeneralStatsPageState extends State<GeneralStatsPage> {
  late Future<List<String>> _districtList;
  late Future<List<String>> _typeList;
  late Future<List<String>> _coachList;

  // String _selectedDate =
  //     DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  String _range =
      "${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}";
  String _selectedDistrict = 'Any';
  String _selectedType = "Any";
  String _selectedCoach = "Any";
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
    _typeList = getTypes();
    _coachList = getCoaches();
  }

  Future<List<String>> getDistricts() async {
    List<String> result = await (districts.getAllDistricts());
    List<String> names = [];
    for (var district in result) {
      names.add(district.split(',')[0]);
    }
    return names;
  }

  Future<List<String>> getTypes() async {
    return await (types.getAllTypes());
  }

  Future<List<String>> getCoaches() async {
    List<String> result = await (coaches.getAllCoaches());
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
                      child: Text("Type:"),
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
                        )),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.15,
                      child: Text("Coach:"),
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
                                value: _selectedCoach == "Any"
                                    ? null
                                    : _selectedCoach,
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
                                    _selectedCoach = newValue!;
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
                          future: _coachList,
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
                onPressed: () async {
                  List<String> range = (_range.split('-'));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GeneralStatsResult(
                                startDate: range[0],
                                endDate: range[1],
                                district: _selectedDistrict,
                                coach: _selectedCoach,
                                type: _selectedType,
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
