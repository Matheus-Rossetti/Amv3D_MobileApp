import 'package:http/http.dart' as http;

Future<String> getForProjectScreen(String token) async {
  final request = await http.post(Uri.parse('http://20.201.114.134/graphql'),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $token",
        "cookie": "authn=$token"
      },
      // body:
      //     '{"query": "query Query { activeUser { name projects { totalCount items { id name models { items { id name previewUrl } } } } } }"}');
      body:
          '{"query": "query Query { activeUser { name projects { totalCount items { name id models { items { id name previewUrl commentThreads { totalCount items { replies { totalCount } } } } } } } } }"}');

  print((request.body));

  // for(int index=0;index<2;index++) {
  //   print(jsonDecode(request.body)['data']['activeUser']
  //   ['projects']['items'][index]['models']['items'][0]['previewUrl']);
  // }

  return request.body;
}

Future<String> getForNotesScreen(String token) async {
  return '';
}

Future<String> getForAccountScreen(String token) async {
  return '';
}

void main() => getForProjectScreen(
    '06f7b155ccd185afb0fa568197dfc591e45e559d0e'); // * add token here
