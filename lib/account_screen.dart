import 'package:amvali3d/login_register.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginRegister()),
                  (Route<dynamic> route) => false);
            },
            child: Text('Logout')));
  }
}
