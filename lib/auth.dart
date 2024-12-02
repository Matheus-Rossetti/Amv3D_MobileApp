import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

import 'config.dart';

Future<String> getToken(String email, String password,
    [String? randomChallenge, String? accessCode]) async {
  // ? func may receive randomChallenge and accessCode from createUser
  if (randomChallenge == null) {
    int rdnChallengeLength = randomBetween(5, 15);
    randomChallenge = randomAlphaNumeric(rdnChallengeLength);

    final accessCodeRequest = await http.post(
      Uri.parse('$serverIp/auth/local/login?challenge=$randomChallenge'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    accessCode = accessCodeRequest.body.toString().substring(57);
  }

  final tokenRequest = await http.post(Uri.parse('$serverIp/auth/token'),
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
}

Future<String> createUser(String email, String password, String name) async {
  int rdnChallengeLength = randomBetween(5, 15);
  String randomChallenge = randomAlphaNumeric(rdnChallengeLength);

  final accessCodeRequest = await http.post(
    Uri.parse('$serverIp/auth/local/register?challenge=$randomChallenge'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password, 'name': name}),
  );

  String accessCode = accessCodeRequest.body.toString().substring(57, 99);

  // ? login user after creation
  String token = await getToken(email, password, randomChallenge, accessCode);

  return token;
}