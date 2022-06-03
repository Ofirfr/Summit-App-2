import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AttendanceCalendarPage extends StatefulWidget {
  const AttendanceCalendarPage({Key? key}) : super(key: key);

  @override
  AttendanceCalendarPageState createState() => AttendanceCalendarPageState();
}

class AttendanceCalendarPageState extends State<AttendanceCalendarPage> {
  String _selectedDate = DateTime.now().toString();
  String _selectedDistrict = 'District';
  String _errors = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value.toString();
    });
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
              child: Text("Select Date and District",
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
                SizedBox(
                  height: screenSize.height * 0.05,
                  width: screenSize.width * 0.18,
                  child: DropdownButton<String>(
                    icon: const Icon(Icons.import_export_sharp),
                    hint: const Text("District"),
                    value: _selectedDistrict == "District"
                        ? null
                        : _selectedDistrict,
                    elevation: 16,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize:
                            screenSize.width * screenSize.height * 0.00001 +
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
                    items: <String>['North', 'South', 'Center', 'Jerusalem']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
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
                      print("Date $_selectedDate");
                      print("District $_selectedDistrict");

                      if (_selectedDistrict == "District") {
                        setState(() {
                          _errors = 'Please select District';
                        });
                        return;
                      }
                      // go to attendance page
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
