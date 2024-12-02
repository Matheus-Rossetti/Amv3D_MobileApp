import 'dart:convert';
import 'package:amvali3d/queries.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SingleNoteScreen extends StatefulWidget {
  const SingleNoteScreen(
      {super.key,
      required this.title,
      required this.city,
      required this.color,
      required this.commentsAmmount,
      required this.notesInfo,
      required this.projectIndex,
      required this.token});

  final String title;
  final String city;
  final Color color;
  final int commentsAmmount;
  final dynamic notesInfo;
  final int projectIndex;
  final String token;

  @override
  State<SingleNoteScreen> createState() => _SingleNoteScreenState();
}

class _SingleNoteScreenState extends State<SingleNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: widget.color.withOpacity(0.1),
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Text(
              widget.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: widget.color),
        body: ListView.builder(
          itemCount: widget.commentsAmmount,
          itemBuilder: (context, index) {
            return FullNode(
              commentsAmmount: widget.commentsAmmount,
              color: widget.color,
              index: index,
              notesInfo: widget.notesInfo,
              projectIndex: widget.projectIndex,
              commentIndex: index,
              token: widget.token,
            );
          },
        ),
      ),
    );
  }
}

class FullNode extends StatefulWidget {
  FullNode(
      {super.key,
      required this.commentsAmmount,
      required this.color,
      required this.index,
      required this.notesInfo,
      required this.projectIndex,
      required this.commentIndex,
      required this.token});

  final int commentsAmmount;
  final Color color;
  final int index;
  dynamic notesInfo;
  final int projectIndex;
  final int commentIndex;
  final String token;

  @override
  State<FullNode> createState() => _FullNodeState();
}

class _FullNodeState extends State<FullNode> {
  final TextEditingController reply = TextEditingController();

  _fetchCommentOwner(int index) {
    return widget.notesInfo['data']['activeUser']['projects']['items']
            [widget.projectIndex]['commentThreads']['items'][index]['author']
        ['name'];
  }

  int _fetchDaysAgo(int index) {
    final String rawDate = widget.notesInfo['data']['activeUser']['projects']
            ['items'][widget.projectIndex]['commentThreads']['items'][index]
        ['createdAt'];
    final DateTime commentDate = DateTime.parse(rawDate);
    final Duration difference = DateTime.now().difference(commentDate);
    return difference.inDays;
  }

  _fetchComment(int index) {
    return widget.notesInfo['data']['activeUser']['projects']['items']
        [widget.projectIndex]['commentThreads']['items'][index]['rawText'];
  }

  _fetchAnswer(int index) {
    return widget.notesInfo['data']['activeUser']['projects']['items']
            [widget.projectIndex]['commentThreads']['items']
        [widget.commentIndex]['replies']['items'][index]['rawText'];
  }

  _fetchAnswerAmmount(int commentIndex) {
    return widget.notesInfo['data']['activeUser']['projects']['items']
            [widget.projectIndex]['commentThreads']['items'][commentIndex]
        ['replies']['totalCount'];
  }

  _fetchAnswerOwner(int index) {
    return widget.notesInfo['data']['activeUser']['projects']['items']
            [widget.projectIndex]['commentThreads']['items']
        [widget.commentIndex]['replies']['items'][index]['author']['name'];
  }

  Future<void> _sendReply() async {
    final String commentId = widget.notesInfo['data']['activeUser']['projects']
            ['items'][widget.projectIndex]['commentThreads']['items']
        [widget.index]['id'];
    String updatedNotesJson =
        await createCommentReply(reply.text, commentId, widget.token);

    setState(() {
      widget.notesInfo = jsonDecode(updatedNotesJson);
    });

    reply.clear();
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
                  Text(_fetchCommentOwner(widget.index),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22)),
                  const Gap(10),
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  const Gap(10),
                  Text('${_fetchDaysAgo(widget.index)} dias atrás',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5))),
                ],
              ),
              const Gap(30),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _fetchComment(widget.index),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 19),
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
                            color: widget.color.withOpacity(0.1),
                            border: Border.all(
                                color: widget.color,
                                style: BorderStyle.solid,
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: reply,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: 'Responder...',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3)),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: widget.color,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: IconButton(
                                      onPressed: _sendReply,
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ))),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: _fetchAnswerAmmount(widget.index),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fetchAnswerOwner(index),
                          style: const TextStyle(
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
