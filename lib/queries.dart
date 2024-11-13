import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';

Future<String> getForProjectScreen(String token) async {
  final request = await http.post(Uri.parse('$serverIp/graphql'),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $token",
        "cookie": "authn=$token"
      },
      body:
          '{"query": "query Query { activeUser { name projects { totalCount items { createdAt name id models { items { id name previewUrl commentThreads { totalCount items { replies { totalCount } } } } } } } } }"}');

  return request.body;
}

Future<String> getForNotesScreen(String token) async {
  final request = await http.post(Uri.parse('$serverIp/graphql'),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $token",
        "cookie": "authn=$token"
      },
      body:
          '{"query": "query Query { activeUser { projects { totalCount items { name id commentThreads { totalCount items { author { name } createdAt rawText } } } } } }"}');

  // print(JsonEncoder.withIndent('  ').convert(jsonDecode(request.body)));

  return request.body;
}

Future<String> getForAccountScreen(String token) async {
  return '';
}

Future<void> deleteFirstAutoProject(String token) async {
  final request = await http.post(Uri.parse('$serverIp/graphql'),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $token",
        "cookie": "authn=$token"
      },
      body:
          '{"query": "query Query { activeUser { projects { items { id name } } } }"}');

  final String firstProjectID = jsonDecode(request.body)['data']['activeUser']
      ['projects']['items'][0]['id'];

  await http.post(Uri.parse('$serverIp/graphql'),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $token",
        "cookie": "authn=$token"
      },
      body:
          '{"query": "mutation ActiveUserMutations(\$deleteId: String!) { projectMutations { delete(id: \$deleteId) } }", "variables": {"deleteId": "$firstProjectID"}}');
}

// * query tests
void main() {
  // getForProjectScreen(
  //     '06f7b155ccd185afb0fa568197dfc591e45e559d0e'); // * add token here
  // deleteFirstAutoProject('06f7b155ccd185afb0fa568197dfc591e45e559d0e');
  getForNotesScreen('06f7b155ccd185afb0fa568197dfc591e45e559d0e');
}
