import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      backgroundColor: Colors.white,
      height: 70,
      // selectedIndex: currentPageIndex,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.auto_awesome_mosaic), label: 'Projetos'),
        NavigationDestination(
            icon: Icon(Icons.folder_shared), label: 'Compartilhado'),
        NavigationDestination(icon: Icon(Icons.speaker_notes), label: 'Notas'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Conta'),
      ],
    );
  }
}
