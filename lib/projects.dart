import 'dart:convert';

import 'package:amvali3d/navbar.dart';
import 'package:amvali3d/queries.dart';
import 'package:flutter/material.dart';

void projectsScreenInfo(context, String token) async {
  String jsonFromRequest = await getForProjectScreen(token);

  int projectAmount = jsonDecode(jsonFromRequest)['data']['activeUser']
      ['projects']['totalCount'];
  String userName = jsonDecode(jsonFromRequest)['data']['activeUser']['name'];

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProjectsScreen(
              userName: userName, projectAmount: projectAmount)));
}

class ProjectsScreen extends StatelessWidget {
  final String userName;
  final int projectAmount;

  const ProjectsScreen(
      {super.key, required this.userName, required this.projectAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(userName),
              floating: true,
            ),
            // ! Container(height: 10, color: Colors.red), don't do this!
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (builder, context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.red,
                        ),
                      ),
                  childCount: projectAmount + 20),
            )
          ],
        ),
        bottomNavigationBar: const NavBar());
  }
}
