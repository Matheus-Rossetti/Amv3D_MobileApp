import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

// import 'web_view.dart';
// import 'package:flutter/material.dart';

Future<String> getToken(String email, String password) async {
  int rdn_challenge_length = randomBetween(5, 15);
  String random_challenge = randomAlphaNumeric(rdn_challenge_length);

  print('Challenge: $random_challenge');

  final accessCodeRequest = await http.post(
    Uri.parse(
        'http://20.201.114.134/auth/local/login?challenge=$random_challenge'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  String accessCode = accessCodeRequest.body.toString().substring(57);

  print(accessCode);

  sleep(Duration(milliseconds: 500));

  final tokenRequest =
      await http.post(Uri.parse('http://20.201.114.134/auth/token'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'appId': 'spklwebapp',
            'appSecret': 'spklwebapp',
            'challenge': random_challenge,
            'accessCode': accessCode
          }));

  String token = (jsonDecode(tokenRequest.body)['token']);
  String refreshToken = (jsonDecode(tokenRequest.body)['refreshToken']);

  print('Token: $token');

  return token;
}

void main() {
  getToken('ti@amvali.org.br', 'Amv@1001');
}
