import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getForProjectScreen(String token) async {
  final request = await http.post(Uri.parse('http://20.201.114.134/graphql'),
      headers: {
        "content-type" : "application/json",
        "authorization": "Bearer $token",
        "cookie": "authn=$token"
      },
      body: '{"query": "query ActiveUser {activeUser {name projects {totalCount}}}"}');

  return request.body;
}


void main() => getForProjectScreen(''); // * add token here
