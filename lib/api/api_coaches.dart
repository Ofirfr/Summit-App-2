import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getActiveCoaches() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "coach/GetActiveCoaches"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> coaches = [];
    for (var res in jsonResponse) {
      coaches.add(res["coachName"] + "," + res["isAdmin"].toString());
    }
    return coaches;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<List<String>> getAllCoaches() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "coach/GetAllCoaches"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> coaches = [];
    for (var res in jsonResponse) {
      String active = res["active"] ? "Yes" : "No";
      String admin = res["isAdmin"] ? "Yes" : "No";
      coaches.add(res["coachName"] + "," + admin + "," + active);
    }
    return coaches;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<String> changeState(String coachName) async {
  var response = await http.post(
      coms.Consts.uriGen(baseUrl, "coach/ChangeCoachState"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode({
        "coachName": coachName,
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
