import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getDistricts() async {
  var response = await http.get(
    coms.Consts.UriGen(baseUrl, "district/GetDistricts"),
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
