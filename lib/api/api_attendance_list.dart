import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getDistrictUsers(String district) async {
  var response = await http.get(
    coms.Consts.uriGen(
        baseUrl, "district/GetUsersByDistrict", {"districtName": district}),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> users = [];
    for (var res in jsonResponse) {
      users.add(res["userName"]);
    }
    users.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return users;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<List<String>> getOtherDistrictsUsers(String district) async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "district/GetUsersByOtherDistricts",
        {"districtName": district}),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> users = [];
    for (var res in jsonResponse) {
      users.add(res["userName"]);
    }
    users.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return users;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<List<String>> sendAttendance(
    List<String> attendance, String date, String type, String district) async {
  List<Map<String, String>> jsonAttendance = List<Map<String, String>>.generate(
      attendance.length, (index) => <String, String>{});
  for (var i = 0; i < attendance.length; i++) {
    Map<String, String> user = jsonAttendance[i];
    user["userName"] = attendance[i];
  }
  var body = convert.jsonEncode({
    "date": date,
    "type": type,
    "districtName": district,
    "usersToMark": jsonAttendance
  });

  var response = await http.post(
      coms.Consts.uriGen(baseUrl, "training/UpdateAttendance"),
      headers: {
        "x-auth-token": coms.Coms.token,
        "content-type": "application/json"
      },
      body: body);
  if (response.statusCode == 200) {
    return [response.body];
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<List<String>> getAttendance(
    String district, String date, String type) async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "training/GetAttendance",
        {"date": date, "type": type, "district": district}),
    headers: {"x-auth-token": coms.Coms.token},
  );

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    jsonResponse = jsonResponse[0]["users"];
    List<String> users = [];
    for (var res in jsonResponse) {
      users.add(res["userName"]);
    }
    users.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return users;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}
