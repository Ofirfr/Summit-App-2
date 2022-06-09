import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getCoaches() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "coach/GetAllCoaches"),
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
