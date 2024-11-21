import 'dart:convert';

import 'package:amvali3d/queries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'config.dart';
import 'project_card.dart';

class ProjectsScreen extends StatefulWidget {
  final String token;

  const ProjectsScreen({super.key, required this.token});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String userName = '';
  int projectAmount = 0;
  dynamic projectsInfo;
  dynamic projects;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjectScreenData();
  }

  Future<void> _fetchProjectScreenData() async {
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

    if (projectsInfo['data']['activeUser']['projects']['items'][0]['name']
        .contains('First Project')) {
      await deleteFirstAutoProject(widget.token);
      await _fetchProjectScreenData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _fetchProjectTitle(int index) {
    String uploadedProjectName =
        projectsInfo['data']['activeUser']['projects']['items'][index]['name'];
    // * get the last word from the string splited by '-'
    String initialName = uploadedProjectName.split('-').last;
    // * replace underlines for spaces, if there's any
    String finalProjectName = initialName.replaceAll('_', ' ');
    // * split the name into a list of words, uppercase the first letter and lower the rest, then join the words together
    finalProjectName = finalProjectName.split(' ').map((word) {
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '';
    }).join(' ');

    return finalProjectName;
  }

  Color _fetchProjectColor(int index) {
    Map<String, Color> cityColor = {
      'JS': const Color(0xff86c226),
      'MS': const Color(0xffe92d2c),
      'SH': const Color(0xff00923f),
      'CR': const Color(0xfff8c301),
      'GM': const Color(0xff00adef),
      'BV': const Color(0xff015198),
      'SJ': const Color(0xfff8931f),
    };
    //* Jaraguá, Massaranduba, Schoroeder, Corupa, Guaramirin, Barra Velha e São João do Itaperiú

    String uploadedName =
        projectsInfo['data']['activeUser']['projects']['items'][index]['name'];

    String city;
    try {
      city = uploadedName.split('-')[1].toUpperCase();
    } catch (e) {
      // * returns grey if the title is different than usual
      return const Color(0xffdbdbdb);
    }
    try {
      return cityColor[city]!;
    }
    // * returns grey if there's no city in the title
    catch (e) {
      return const Color(0xffdbdbdb);
    }
  }

  String _fetchProjectCity(int index) {
    Map<String, String> cityName = {
      'JS': 'Jaraguá do Sul',
      'MS': 'Massaranduba',
      'SH': 'Schroeder',
      'CR': 'Corupá',
      'GM': 'Guaramirim',
      'BV': 'Barra Velha',
      'SJ': 'São João',
    };

    String uploadedProjectName =
        projectsInfo['data']['activeUser']['projects']['items'][index]['name'];

    try {
      String cityAcronym = uploadedProjectName.split('-')[1].toUpperCase();
      return cityName[cityAcronym]!;
      // * returns 'desconhecido' if the title is different than usual
    } catch (e) {
      return 'Amvali';
    }
  }

  String _fetchProjectDate(int index) {
    String uploadedDate = projectsInfo['data']['activeUser']['projects']
        ['items'][index]['createdAt'];

    DateTime datedDate = DateTime.parse(uploadedDate);

    String formatedDate = DateFormat('dd/MM/yy').format(datedDate);

    return formatedDate;
  }

  String _fetchProjectUrl(int index) {
    String projectId =
        projectsInfo['data']['activeUser']['projects']['items'][index]['id'];
    String modelId = projectsInfo['data']['activeUser']['projects']['items']
        [index]['models']['items'][0]['id'];

    return '$serverIp/projects/$projectId/models/$modelId';
  }

  String _fetchCommentsAmount(int index) {
    int commentsAmount = projectsInfo['data']['activeUser']['projects']['items']
        [index]['models']['items'][0]['commentThreads']['totalCount'];

    return commentsAmount.toString();
  }

  String _fetchProjectImage(int index) {
    String imageUrl = projectsInfo['data']['activeUser']['projects']['items']
        [index]['models']['items'][0]['previewUrl'];

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff088240),
      onRefresh: _fetchProjectScreenData,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
              centerTitle: false,
              leading: const SizedBox(),
              backgroundColor: Colors.white,
              title: Text(userName)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (builder, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                    child: _isLoading == true
                        ? const ProjectContainerShimmer()
                        : ProjectContainer(
                            token: widget.token,
                            title: _fetchProjectTitle(index),
                            color: _fetchProjectColor(index),
                            city: _fetchProjectCity(index),
                            date: _fetchProjectDate(index),
                            imageUrl: _fetchProjectImage(index),
                            url: _fetchProjectUrl(index),
                            commentsAmount: _fetchCommentsAmount(index))),
                childCount: projectAmount),
          )
        ],
      ),
    );
  }
}
