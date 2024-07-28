import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/src/screens/add_post.dart';
import 'package:instagram_flutter/src/screens/feed_screen.dart';
import 'package:instagram_flutter/src/screens/profile_screen.dart';
import 'package:instagram_flutter/src/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];