import 'package:flutter/material.dart';





class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('tela de menu'));
  }
}
