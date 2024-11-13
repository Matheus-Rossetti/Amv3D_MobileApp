import 'dart:convert';

import 'package:amvali3d/navigation.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

import 'queries.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, required this.token});

  final String token;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  dynamic _notesInfo = '';
  int _projectsAmmount = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotesScreenData();
  }

  Future<void> _fetchNotesScreenData() async {
    setState(() {
      _isLoading = true;
    });

    String notesJson = await getForNotesScreen(widget.token);

    setState(() {
      _notesInfo = jsonDecode(notesJson);
      _projectsAmmount =
          _notesInfo['data']['activeUser']['projects']['totalCount'];
    });

    setState(() {
      _isLoading = false;
    });

    return;
  }

  String _fetchNotesProjectName(int index) {
    String uploadedProjectName =
        _notesInfo['data']['activeUser']['projects']['items'][index]['name'];
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
        _notesInfo['data']['activeUser']['projects']['items'][index]['name'];

    try {
      String cityAcronym = uploadedProjectName.split('-')[1].toUpperCase();
      return cityName[cityAcronym]!;
      // * returns 'desconhecido' if the title is different than usual
    } catch (e) {
      return 'Amvali';
    }
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
        _notesInfo['data']['activeUser']['projects']['items'][index]['name'];

    final String city;
    try {
      city = uploadedName.split('-')[1].toUpperCase();
    } catch (e) {
      // * returns grey if the title is different than usual
      return const Color(0xffdbdbdb);
    }

    return cityColor[city]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          onRefresh: _fetchNotesScreenData,
          child: NotesCard(
              title: _fetchProjectCity(0),
              city: _fetchProjectCity(0),
              color: _fetchProjectColor(0))

          // CustomScrollView(slivers: [
          //   const SliverAppBar(
          //       centerTitle: false,
          //       leading: SizedBox(),
          //       backgroundColor: Colors.white,
          //       title: Text('Notas')),
          //   SliverList(
          //       delegate: SliverChildBuilderDelegate(
          //           (builder, index) => NotesCard(
          //                 title: _fetchNotesProjectName(index),
          //                 city: _fetchProjectCity(index),
          //                 color: _fetchProjectColor(index),
          //               ),
          //           childCount: _projectsAmmount))
          // ]),
          ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    required this.title,
    required this.city,
    required this.color,
  });

  final String title;
  final String city;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      city,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text('inicio da timeline'),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.brown,
                height: 500,
                width: 300,
                child: Timeline.tileBuilder(
                  builder: TimelineTileBuilder.connectedFromStyle(
                    nodePositionBuilder: (context, index) => 0,
                    // indicatorStyle: DotIndicator(color: ),
                    contentsAlign: ContentsAlign.basic,
                    contentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text('Timeline Event $index'),
                    ),
                    itemCount: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
