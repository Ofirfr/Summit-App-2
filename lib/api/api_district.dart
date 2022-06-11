import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getActiveDistricts() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "district/GetActiveDistricts"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> districs = [];
    for (var res in jsonResponse) {
      districs.add(res["name"]);
    }
    return districs;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<List<String>> getAllDistricts() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "district/GetAllDistricts"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> districs = [];
    for (var res in jsonResponse) {
      String active = res["active"] ? "Yes" : "No";
      districs.add(res["name"] + "," + active);
    }
    return districs;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<String> changeState(String districtName) async {
  var response = await http.post(
      coms.Consts.uriGen(baseUrl, "district/ChangeDistrictState"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode({
        "districtName": districtName,
      }));
  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"]);
  }
  return "Error";
}
