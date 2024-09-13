import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/pages/comments.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/resources/firestore.dart';
import 'package:social_media/util/colors.dart';
import 'package:social_media/util/global_variables.dart';
import 'package:social_media/util/utils.dart';
import 'package:social_media/widgets/like.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimation = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: width > webScreenSize
                    ? secondaryColor
                    : mobileBackgroundColor,
              ),
              color: mobileBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(
                    right: 0,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            NetworkImage(widget.snap['profileImage']),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap['username'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              String res = await Firestore()
                                                  .deletePost(
                                                      widget.snap['postId'],
                                                      user.uid,
                                                      widget.snap['uid']);
                                              showSnackBar(context, res);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 16,
                                              ),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                      ),
                    ],
                  ),
                ),
                //Image section
                GestureDetector(
                  onDoubleTap: () async {
                    await Firestore().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                    setState(() {
                      isLikeAnimation = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        opacity: isLikeAnimation ? 1 : 0,
                        child: Like(
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 100,
                          ),
                          isAnimating: isLikeAnimation,
                          onEnd: () {
                            setState(() {
                              isLikeAnimation = false;
                            });
                          },
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Like comment
                Row(
                  children: [
                    Like(
                      isAnimating: widget.snap['likes'].contains(user.uid),
                      smallLike: true,
                      onEnd: () {},
                      child: IconButton(
                          onPressed: () async {
                            await Firestore().likePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes'],
                            );
                          },
                          icon: (widget.snap['likes']).contains(user.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                )),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: Text(
                            DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //description and #of comments
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          '${widget.snap['likes'].length} Likes',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 4,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: '${widget.snap['username']}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.snap['description'],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () => Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (context) => Comments(
                      //         postId: widget.snap['postId'].toString(),
                      //       ),
                      //     ),
                      //   ),
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(vertical: 4),
                      //     child: Text(
                      //       'View all ${commentLen} comments',
                      //       style: const TextStyle(
                      //         fontSize: 16,
                      //         color: secondaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Comments(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
