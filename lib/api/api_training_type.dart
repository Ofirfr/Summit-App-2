import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<List<String>> getActiveTypes() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "type/GetActiveTrainingTypes"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> types = [];
    for (var res in jsonResponse) {
      types.add(res["type"]);
    }
    return types;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<List<String>> getAllTypes() async {
  var response = await http.get(
    coms.Consts.uriGen(baseUrl, "type/GetAllTrainingTypes"),
    headers: {"x-auth-token": coms.Coms.token},
  );
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
    List<String> types = [];
    for (var res in jsonResponse) {
      String active = res["active"] ? "Yes" : "No";
      types.add(res["type"] + "," + active);
    }
    return types;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"]);
  }
  return ["Error"];
}

Future<String> changeState(String typeName) async {
  var response = await http.post(
      coms.Consts.uriGen(baseUrl, "type/ChangeTypeState"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode({
        "typeName": typeName,
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
