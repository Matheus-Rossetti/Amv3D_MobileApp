import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SingleNoteScreen extends StatelessWidget {
  const SingleNoteScreen(
      {super.key,
      required this.title,
      required this.city,
      required this.color,
      required this.commentsAmmount,
      required this.notesInfo,
      required this.projectIndex});

  final String title;
  final String city;
  final Color color;
  final int commentsAmmount;
  final dynamic notesInfo;
  final int projectIndex;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: color.withOpacity(0.1),
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: color),
        body: ListView.builder(
          itemCount: commentsAmmount,
          itemBuilder: (context, index) {
            return FullNode(
              commentsAmmount: commentsAmmount,
              color: color,
              index: index,
              notesInfo: notesInfo,
              projectIndex: projectIndex,
              commentIndex: index,
            );
          },
        ),
      ),
    );
  }
}

class FullNode extends StatelessWidget {
  const FullNode(
      {super.key,
      required this.commentsAmmount,
      required this.color,
      required this.index,
      required this.notesInfo,
      required this.projectIndex,
      required this.commentIndex});

  final int commentsAmmount;
  final Color color;
  final int index;
  final dynamic notesInfo;
  final int projectIndex;
  final int commentIndex;

  _fetchCommentOwner(int index) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
        ['commentThreads']['items'][index]['author']['name'];
  }

  int _fetchDaysAgo(int index) {
    final String rawDate = notesInfo['data']['activeUser']['projects']['items']
        [projectIndex]['commentThreads']['items'][index]['createdAt'];
    final DateTime commentDate = DateTime.parse(rawDate);
    final Duration difference = DateTime.now().difference(commentDate);
    return difference.inDays;
  }

  _fetchComment(int index) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
        ['commentThreads']['items'][index]['rawText'];
  }

  _fetchAnswer(int index) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
            ['commentThreads']['items'][commentIndex]['replies']['items'][index]
        ['rawText'];
  }

  _fetchAnswerAmmount(int commentIndex) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
        ['commentThreads']['items'][commentIndex]['replies']['totalCount'];
  }

  _fetchAnswerOwner(int index) {
    return notesInfo['data']['activeUser']['projects']['items'][projectIndex]
            ['commentThreads']['items'][commentIndex]['replies']['items'][index]
        ['author']['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(_fetchCommentOwner(index),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22)),
                  const Gap(10),
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  const Gap(10),
                  Text('${_fetchDaysAgo(index)} dias atrás',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5))),
                ],
              ),
              const Gap(30),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _fetchComment(index),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
                ),
              ),
              // Divider(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            border: Border.all(
                                color: color,
                                style: BorderStyle.solid,
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: 'Responder...',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3)),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Gap(5),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Expanded(
                        flex: 1,
                        child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6)),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ))),
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _fetchAnswerAmmount(index),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fetchAnswerOwner(index),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(_fetchAnswer(index)),
                        ),
                        const Divider()
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
