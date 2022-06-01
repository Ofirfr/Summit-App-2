import 'dart:convert' as convert;
import "package:http/http.dart" as http;

Future<String> login(String userName, String password) async {
  var response = await http.post(
      Uri.https("4188-2a00-a040-19f-8ec8-9d33-afc0-ec31-cd43.eu.ngrok.io",
          "coach/Login"),
      headers: {"content-type": "application/json"},
      body: convert.jsonEncode({"coachName": userName, "password": password}));
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    String token = jsonResponse["token"];
    print(token);
    return "";
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}
