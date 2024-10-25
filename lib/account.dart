import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  final user = 'user';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        const SizedBox(height: 100),
        const Text('Conta', style: TextStyle(fontSize: 50)),
        const SizedBox(height: 40),
        Text(user, style: const TextStyle(fontSize: 40)),
      ]);
  }
}
