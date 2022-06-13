import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import '../coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<String> addCoach(String coachName, String password, bool isAdmin) async {
  var response = await http.post(coms.Consts.uriGen(baseUrl, "coach/AddCoach"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode(
          {"coachName": coachName, "password": password, "isAdmin": isAdmin}));
  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}

Future<String> addType(String type) async {
  var response = await http.post(
      coms.Consts.uriGen(baseUrl, "type/AddTrainingType"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode({"type": type}));
  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}

Future<String> addDistrict(String districtName) async {
  var response = await http.post(
      coms.Consts.uriGen(baseUrl, "district/AddDistrict"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode({"districtName": districtName}));
  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}
