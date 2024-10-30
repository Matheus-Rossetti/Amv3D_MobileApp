import 'dart:convert';

import 'package:amvali3d/queries.dart';
import 'package:amvali3d/web_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'navigation.dart';

class ProjectsScreen extends StatefulWidget {
  final String token;

  const ProjectsScreen({super.key, required this.token});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String userName = '';
  int projectAmount = 3;
  List<dynamic> projects = ['', ''];
  dynamic projectsInfo;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjectData();
  }

  Future<void> _fetchProjectData() async {
    setState(() {
      _isLoading = true;
    });

    String projectsJson = await getForProjectScreen(widget.token);

    setState(() {
      projectsInfo = jsonDecode(projectsJson);
      projectAmount =
          (projectsInfo['data']['activeUser']['projects']['totalCount'] as int);
      userName = projectsInfo['data']['activeUser']['name'];
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Color(0xff088240),
          onRefresh: _fetchProjectData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                  centerTitle: false,
                  leading: SizedBox(),
                  backgroundColor: Colors.white,
                  title: Text(userName)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (builder, index) => Padding(
                        padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                        child: _isLoading == true
                            ? const ProjectContainerShimmer()
                            : ProjectContainer(
                                projectsInfo: projectsInfo, index: index)),
                    childCount: projectAmount),
              )
            ],
          ),
        ),
        bottomNavigationBar: const NavBar());
  }
}

class ProjectContainer extends StatelessWidget {
  const ProjectContainer({
    super.key,
    required this.projectsInfo,
    required this.index,
  });

  final dynamic projectsInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xff088240), Color(0xff7eae2b)],
            stops: [0.25, 0.75],
            begin: Alignment(1.0, -2.0),
            end: Alignment.bottomLeft,
          )),
      // color: const Color(0xff088240)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  // *very important!
                  padding: const EdgeInsets.only(left: 2),
                  // *very important!
                  child: Text(
                    projectsInfo['data']['activeUser']['projects']['items']
                        [index]['name'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  String projectId = projectsInfo['data']['activeUser']
                      ['projects']['items'][index]['id'];
                  String modelId = projectsInfo['data']['activeUser']
                      ['projects']['items'][index]['models']['items'][0]['id'];

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebView(
                              url:
                                  'http://20.201.114.134/projects/$projectId/models/$modelId')));
                },
                child: Image.network(
                  projectsInfo['data']['activeUser']['projects']['items'][index]
                      ['models']['items'][0]['previewUrl'],
                  scale: 1.5,
                  fit: BoxFit.none,
                  alignment: Alignment.bottomCenter,
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dono: xxxxxxx'),
                Column(
                  children: [
                    Text('Upload: xx/xx/xx'),
                    Text('Última modificação: xx/xx/xx')
                  ],
                )
              ],
            ),

            // const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: TextButton(
                      // * action button
                      onPressed: () {},
                      child: Text(
                        "Compartilhar",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                Container(
                  width: 70,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: TextButton(
                      // * action button
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.message, color: Colors.black),
                          Text(projectsInfo['data']['activeUser']['projects']
                                      ['items'][index]['models']['items'][0]
                                  ['commentThreads']['totalCount']
                              .toString())
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProjectContainerShimmer extends StatelessWidget {
  const ProjectContainerShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 430,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.grey),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      // *very important!
                      padding: const EdgeInsets.only(left: 2),
                      // *very important!
                      child: Shimmer.fromColors(
                          baseColor: Colors.black38,
                          highlightColor: Colors.black12,
                          child: Container(
                            height: 13,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Shimmer.fromColors(
                  baseColor: Colors.black38,
                  highlightColor: Colors.black12,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(''),
                    Column(
                      children: [Text(''), Text('')],
                    )
                  ],
                ),

                // const SizedBox(height: 50),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.black38,
                        highlightColor: Colors.black12,
                        child: Container(
                          width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.black38,
                        highlightColor: Colors.black12,
                        child: Container(
                          width: 60,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ])
              ],
            )));
  }
}
