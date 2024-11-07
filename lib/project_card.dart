import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'web_view.dart';

class ProjectContainer extends StatelessWidget {
  const ProjectContainer({
    super.key,
    required this.token,
    required this.title,
    required this.color,
    required this.city,
    required this.date,
    required this.imageUrl,
    required this.url,
    required this.commentsAmount,
  });

  final String token;
  final String title;
  final Color color;
  final String city;
  final String date;
  final String imageUrl;
  final String url;
  final String commentsAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      width: 100,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      // color: const Color(0xff088240)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                // *very important!
                padding: const EdgeInsets.only(left: 2),
                // *very important!
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      city,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        date,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                )
              ],
            ),
            const SizedBox(height: 5),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebView(url: url, token: token)));
                },
                child: Image.network(
                  imageUrl,
                  headers: {
                    // 'Authorization': 'Bearer $token',
                    'Cookie': 'authn=$token'
                  },
                  scale: 1.5,
                  fit: BoxFit.none,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            const Spacer(),
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
                      child: const Text(
                        "Compartilhar",
                        style: TextStyle(
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
                          const Icon(Icons.message, color: Colors.black),
                          Text(commentsAmount)
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
                const Row(
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
