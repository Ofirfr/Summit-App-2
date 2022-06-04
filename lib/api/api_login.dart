import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<String> login(String userName, String password) async {
  var response = await http.post(Uri.http(baseUrl, "coach/Login"),
      headers: {"content-type": "application/json"},
      body: convert.jsonEncode({"coachName": userName, "password": password}));
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    coms.Coms.token = jsonResponse["token"];
    return "";
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}
