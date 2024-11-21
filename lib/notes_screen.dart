import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:timeline_tile/timeline_tile.dart';

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

    try {
      final String city = uploadedName.split('-')[1].toUpperCase();
      return cityColor[city]!;
    } catch (e) {
      // * returns grey if the title is different than usual
      return const Color(0xffdbdbdb);
    }
  }

  int _fetchCommentsAmmount(int index) {
    int commentAmmount = _notesInfo['data']['activeUser']['projects']['items']
        [index]['commentThreads']['totalCount'];

    // * limits the ammount to 4 inside the card
    return commentAmmount > 4 ? 4 : commentAmmount;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchNotesScreenData,
      child: CustomScrollView(slivers: [
        const SliverAppBar(
            centerTitle: false,
            leading: SizedBox(),
            backgroundColor: Colors.white,
            title: Text('Notas')),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (builder, index) => NotesCard(
                      commentsAmmount: _fetchCommentsAmmount(index),
                      title: _fetchNotesProjectName(index),
                      city: _fetchProjectCity(index),
                      color: _fetchProjectColor(index),
                      notesInfo: _notesInfo,
                      projectIndex: index,
                    ),
                childCount: _projectsAmmount))
      ]),
    );
  }
}

class NotesCard extends StatelessWidget {
  const NotesCard(
      {super.key,
      required this.commentsAmmount,
      required this.title,
      required this.city,
      required this.color,
      required this.notesInfo,
      required this.projectIndex});

  final int commentsAmmount;
  final String title;
  final String city;
  final Color color;
  final dynamic notesInfo;
  final int projectIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color,
            width: 2,
            style: BorderStyle.solid,
          ),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 10),
              child: Align(
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
            ),
            const Gap(12),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: List.generate(commentsAmmount, (index) {
                    return TimelineTile(
                      isFirst: index == 0,
                      isLast: (index + 1) == commentsAmmount,
                      beforeLineStyle:
                          const LineStyle(thickness: 1, color: Colors.black),
                      indicatorStyle: IndicatorStyle(
                          width: 8, color: color, indicatorXY: 0.15),
                      endChild: Node(
                          index: index,
                          notesInfo: notesInfo,
                          projectIndex: projectIndex),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO Move '_fetch' functions to a separate file

class Node extends StatelessWidget {
  const Node(
      {super.key,
      required this.index,
      required this.notesInfo,
      required this.projectIndex});

  final int index;
  final dynamic notesInfo;
  final int projectIndex;

  _fetchCommentOwner(int index) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
        ['commentThreads']['items'][index]['author']['name'];
  }

  _fetchComment(int index) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
        ['commentThreads']['items'][index]['rawText'];
  }

  int _fetchDaysAgo(int index) {
    final String rawDate = notesInfo['data']['activeUser']['projects']['items']
        [projectIndex]['commentThreads']['items'][index]['createdAt'];
    final DateTime commentDate = DateTime.parse(rawDate);
    final Duration difference = DateTime.now().difference(commentDate);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          Row(
            children: [
              Text(_fetchCommentOwner(index),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const Gap(10),
              CircleAvatar(
                radius: 3,
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
              const Gap(10),
              Text('${_fetchDaysAgo(index)} dias atrás',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5)))
            ],
          ),
          const Gap(5),
          Align(
            alignment: Alignment.topLeft,
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2), width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(_fetchComment(index)),
                          // Gap(5),
                          // Text('+ ')
                        ],
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
