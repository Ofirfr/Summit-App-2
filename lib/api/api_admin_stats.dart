import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<dynamic>> statsByParams(String coachName, String typeName,
    String districtName, String startDate, String endDate) async {
  var response = await http.get(
      coms.Consts.uriGen(baseUrl, "stats/StatsByParams", {
        "coachName": coachName,
        "typeName": typeName,
        "districtName": districtName,
        "startDate": startDate,
        "endDate": endDate
      }),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      });
  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"]);
  }
  return ["Error"];
}
