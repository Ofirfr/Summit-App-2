import 'dart:convert' as convert;
import "package:http/http.dart" as http;
import 'coms.dart' as coms;

const String baseUrl = coms.Consts.ip;

Future<String> addMember(
    String userName, String email, String phoneNumber, String district) async {
  var response = await http.post(coms.Consts.UriGen(baseUrl, "user/AddUser"),
      headers: {
        "content-type": "application/json",
        "x-auth-token": coms.Coms.token
      },
      body: convert.jsonEncode({
        "email": email,
        "userName": userName,
        "phoneNumber": phoneNumber,
        "mainDistrict": district
      }));
  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 400) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return (jsonResponse["errors"][0]["msg"].toString());
  }
  return "Error";
}
