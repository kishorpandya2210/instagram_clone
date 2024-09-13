import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/pages/feed.dart';
import 'package:social_media/pages/post.dart';
import 'package:social_media/pages/profile.dart';

import '../pages/search.dart';

const webScreenSize = 600;

List<Widget> screens = [
  Feed(),
  Search(),
  Post(),
  Profile(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
