import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<String> login(String userName, String password) async {
  var response = await http.post(coms.Consts.uriGen(baseUrl, "coach/Login"),
      headers: {"content-type": "application/json"},
      body: convert.jsonEncode({"coachName": userName, "password": password}));
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    coms.Coms.token = jsonResponse["token"];
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString("token", coms.Coms.token);
      },
    );
    return "";
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}

Future<String> loginWithToken(String token) async {
  var response = await http.post(
    coms.Consts.uriGen(baseUrl, "coach/LoginWithToken"),
    headers: {"content-type": "application/json", "x-auth-token": token},
  );
  if (response.statusCode == 200) {
    coms.Coms.token = token;
    return response.body;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}
