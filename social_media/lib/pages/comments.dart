import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/resources/firestore.dart';
import 'package:social_media/util/colors.dart';

import '../models/user.dart';
import '../util/utils.dart';
import '../widgets/comment_card.dart';

class Comments extends StatefulWidget {
  final postId;
  const Comments({super.key, required this.postId});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await Firestore().postComment(
        widget.postId,
        _commentController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        _commentController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: mobileSearchColor,
            child: Column(
              children: [
                Title(
                  color: primaryColor,
                  child: const Text(
                    'Comments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 165,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postId)
                          .collection('comments')
                          .orderBy(
                            'datePublished',
                            descending: false,
                          )
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.length == 0) {
                          return const Center(
                            child: const Text('Be the first to comment'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => CommentCard(
                            snap: snapshot.data!.docs[index],
                          ),
                        );
                      }),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: kToolbarHeight,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.image),
                            radius: 18,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 8,
                              ),
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Comment as ${user.username}',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => postComment(
                              user.uid,
                              user.username,
                              user.image,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: const Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: mobileBackgroundColor,
    //     title: const Text('Comments'),
    //     centerTitle: false,
    //   ),
    // body: StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection('posts')
    //         .doc(widget.postId)
    //         .collection('comments')
    //         .orderBy(
    //           'datePublished',
    //           descending: false,
    //         )
    //         .snapshots(),
    //     builder: (context,
    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       return ListView.builder(
    //         itemCount: snapshot.data!.docs.length,
    //         itemBuilder: (context, index) => CommentCard(
    //           snap: snapshot.data!.docs[index],
    //         ),
    //       );
    //     }),
    // bottomNavigationBar: SafeArea(
    //   child: Container(
    //     height: kToolbarHeight,
    //     margin: EdgeInsets.only(
    //       bottom: MediaQuery.of(context).viewInsets.bottom,
    //     ),
    //     padding: const EdgeInsets.only(
    //       left: 16,
    //       right: 8,
    //     ),
    //     child: Row(
    //       children: [
    //         CircleAvatar(
    //           backgroundImage: NetworkImage(user.image),
    //           radius: 18,
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.only(
    //               left: 16,
    //               right: 8,
    //             ),
    //             child: TextField(
    //               controller: _commentController,
    //               decoration: InputDecoration(
    //                 hintText: 'Comment as ${user.username}',
    //                 border: InputBorder.none,
    //               ),
    //             ),
    //           ),
    //         ),
    //         InkWell(
    //           onTap: () => postComment(
    //             user.uid,
    //             user.username,
    //             user.image,
    //           ),
    //           child: Container(
    //             padding: const EdgeInsets.symmetric(
    //               vertical: 8,
    //               horizontal: 8,
    //             ),
    //             child: const Text(
    //               'Post',
    //               style: TextStyle(
    //                 color: Colors.blueAccent,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
    // );
  }
}
