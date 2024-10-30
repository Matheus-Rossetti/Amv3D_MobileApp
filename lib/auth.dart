import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

Future<String> getToken(String email, String password,
    [String? randomChallenge, String? accessCode]) async {
  try {
    // ? func may receive randomChallenge and accessCode from createUser
    if (randomChallenge == null) {
      int rdnChallengeLength = randomBetween(5, 15);
      randomChallenge = randomAlphaNumeric(rdnChallengeLength);

      final accessCodeRequest = await http.post(
        Uri.parse(
            'http://20.201.114.134/auth/local/login?challenge=$randomChallenge'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print(accessCodeRequest.body);

      accessCode = accessCodeRequest.body.toString().substring(57);
    }

    final tokenRequest =
        await http.post(Uri.parse('http://20.201.114.134/auth/token'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'appId': 'spklwebapp',
              'appSecret': 'spklwebapp',
              'challenge': randomChallenge,
              'accessCode': accessCode
            }));

    String token = (jsonDecode(tokenRequest.body)['token']);
    String refreshToken = (jsonDecode(tokenRequest.body)['refreshToken']);

    return token;
  } catch (e) {
    print(e);
    return '';
  }
}

Future<String> createUser(String email, String password, String name) async {
  int rdnChallengeLength = randomBetween(5, 15);
  String randomChallenge = randomAlphaNumeric(rdnChallengeLength);

  final accessCodeRequest = await http.post(
    Uri.parse(
        'http://20.201.114.134/auth/local/register?challenge=$randomChallenge'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password, 'name': name}),
  );

  String accessCode = accessCodeRequest.body.toString().substring(57, 99);

  // ? login user after creation
  String token = await getToken(email, password, randomChallenge, accessCode);

  return token;
}

// * testing the calls
void main() {
  // getToken('ti@amvali.org.br', 'Amv@1001',);
  createUser(
    'teste@gmail.com',
    'Matheus-16',
    'teste',
  );
}
