import 'package:flutter/material.dart';
import '../../api/api_admin_add.dart' as api_add;
import '../../api/api_district.dart' as api_show;
import 'package:jwt_decode/jwt_decode.dart';
import '../../api/coms.dart';

class DistrictPage extends StatelessWidget {
  const DistrictPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Summit Running and Fitness"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: true,
      body: const DistrictPageScreen(),
    );
  }
}

class DistrictPageScreen extends StatefulWidget {
  const DistrictPageScreen({Key? key}) : super(key: key);

  @override
  _DistrictPageScreenState createState() => _DistrictPageScreenState();
}

class _DistrictPageScreenState extends State<DistrictPageScreen> {
  TextEditingController districtNameController = TextEditingController();
  late Future<List<String>> _districts;
  String _errors = "";
  final Map<String, dynamic> payload = Jwt.parseJwt(Coms.token);

  @override
  void initState() {
    super.initState();
    _districts = getDistricts();
  }

  Future<List<String>> getDistricts() async {
    List<String> districts = await api_show.getDistricts();
    return districts;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Align(
                alignment: Alignment.center,
                child: Text(
                  "All Districts",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              width: screenSize.width * 0.7,
              child: FutureBuilder(
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> names = snapshot.data as List<String>;
                      DataTable districtTable = DataTable(
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
                      return districtTable;
                    } else {
                      return const LinearProgressIndicator();
                    }
                  }),
                  future: _districts),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Add District",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenSize.width * screenSize.height * 0.00003 + 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              height: screenSize.height * 0.04,
              width: 10,
            ),
            SizedBox(
              width: screenSize.width * 0.9,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                          width: screenSize.width * 0.2,
                          child: const Text("District Name")),
                      SizedBox(
                          width: screenSize.width * 0.5,
                          child: TextFormField(
                            onTap: () {},
                            controller: districtNameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "District Name",
                                contentPadding: EdgeInsets.all(20)),
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                          )),
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Container(
                    width: 570,
                    height: 100,
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                        onPressed: () async {
                          String districtName = (districtNameController.text);
                          String result =
                              await api_add.addDistrict(districtName);
                          if (result == "District added succesfully") {
                            setState(() {
                              _districts = getDistricts();
                              _errors = '';
                              districtNameController.clear();
                            });
                          } else {
                            setState(() {
                              _errors = result;
                            });
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        )),
                  ),
                  Text(_errors,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontFamily: 'Pacifico'))
                ],
              ),
            ),
          ],
        ));
  }
}
