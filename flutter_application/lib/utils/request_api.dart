import 'dart:convert';
import 'package:http/http.dart' as http;

// APIの要求を行い応答を取得する
Future<String> requestAPI(
    {required String requestBody, required String api}) async {
  Uri url = Uri.parse('http://10.0.2.2:5000/${api}');
  var headers = {"Content-Type": "application/json", "charset": "utf8"};
  http.Response response =
      await http.post(url, headers: headers, body: requestBody);
  String _content;
  if (response.statusCode != 200) {
    int statusCode = response.statusCode;
    _content = "Failed to post $statusCode";
  } else {
    _content = response.body;
  }
  return _content;
}
