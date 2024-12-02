import 'package:amvali3d/account_screen.dart';
import 'package:amvali3d/notes_screen.dart';
import 'package:amvali3d/projects_screen.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.token});

  final String token;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      ProjectsScreen(token: widget.token),
      NotesScreen(token: widget.token),
      AccountScreen(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentPageIndex,
        children: pages, // Renderiza todas as páginas uma vez
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        height: 70,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.auto_awesome_mosaic_outlined),
              selectedIcon: Icon(Icons.auto_awesome_mosaic),
              label: 'Projetos'),
          NavigationDestination(
              icon: Icon(Icons.speaker_notes_outlined),
              selectedIcon: Icon(Icons.speaker_notes),
              label: 'Comentários'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Conta'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        animationDuration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
