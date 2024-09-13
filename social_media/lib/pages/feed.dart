import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/util/colors.dart';
import 'package:social_media/util/global_variables.dart';
import 'package:social_media/widgets/post_card.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Title(
                color: primaryColor,
                child: const Text(
                  'SocialMedia',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return width > webScreenSize
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width * 0.3,
                      vertical: 15,
                    ),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ),
                )
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: PageController(viewportFraction: 1),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
        }),
      ),
    );
  }
}
