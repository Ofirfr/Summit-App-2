import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import '../coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getAllUsers() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "user/GetAllUsers"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> users = [];
    for (var res in jsonResponse) {
      String active = res["active"] ? "Yes" : "No";
      users.add(res["userName"] + "," + active);
    }
    return users;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}
