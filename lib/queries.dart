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
          '{"query": "query Query { activeUser { projects { totalCount items { name id commentThreads { totalCount items { id createdAt rawText author { name } replies { totalCount items{ rawText author{ name } } } } } } } } }"}');

  // print(JsonEncoder.withIndent('  ').convert(jsonDecode(request.body)));

  return request.body;
}

Future<void> getForAccountScreen(String token) async {
  return;
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

// * Doesn't really work :(
Future<dynamic> createCommentReply(String reply, String commentId, String token) async {

  await http.post(Uri.parse('$serverIp/graphql'),
      headers: {
      "content-type": "application/json",
      "authorization": "Bearer $token",
      "cookie": "authn=$token"
      },
      body: jsonEncode({
        'query': '''
      mutation CreateCommentReply(\$input: CreateCommentReplyInput!) {
        commentMutations {
          reply(input: \$input) {
            id
            archived
            rawText
            text {
              doc
              __typename
            }
            author {
              id
              name
              avatar
              __typename
            }
            createdAt
            text {
              attachments {
                id
                fileName
                fileType
                fileSize
                __typename
              }
              __typename
            }
            __typename
          }
          __typename
        }
      }
    ''',
        'variables': {
          'input': {
            'content': {
              'doc': {
                'type': 'doc',
                'content': [
                  {
                    'type': 'paragraph',
                    'content': [
                      {
                        'type': 'text',
                        'text': reply,
                      }
                    ],
                  }
                ],
              },
              'blobIds': [],
            },
            'threadId': commentId,
          }
        }
      })
  );




  return getForNotesScreen(token);
}

// * query tests
void main() {
  // getForProjectScreen(
  //     '06f7b155ccd185afb0fa568197dfc591e45e559d0e'); // * add token here
  // deleteFirstAutoProject('06f7b155ccd185afb0fa568197dfc591e45e559d0e');
  getForNotesScreen('06f7b155ccd185afb0fa568197dfc591e45e559d0e');
}
