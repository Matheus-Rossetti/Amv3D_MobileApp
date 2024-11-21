import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Tela de conta'));
  }
}
