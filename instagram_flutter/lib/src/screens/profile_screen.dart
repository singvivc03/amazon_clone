import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/src/resources/util.dart';
import 'package:instagram_flutter/src/widgets/follow_button.dart';
import 'package:instagram_flutter/utils/colors.dart';

class ProfileScreen extends StatefulWidget {

  final String uid;

  const ProfileScreen({
    super.key,
    required this.uid
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      setState(() {
        userData = snapshot.data()!;
      });
    } catch (err) {
      if (mounted) {
        showSnackBar(err.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),

                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(20, 'Posts'),
                              buildStatColumn(150, 'Followers'),
                              buildStatColumn(10, 'Following'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: const Text('username', style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 2),
                  child: const Text('description',),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FollowButton(
                        backGroundColor: Colors.white12,
                        borderColor: Colors.grey,
                        text: 'Edit profile',
                        textColor: primaryColor,
                        function: () {},
                      ),
                      FollowButton(
                        backGroundColor: Colors.white12,
                        borderColor: Colors.grey,
                        text: 'Share profile',
                        textColor: primaryColor,
                        function: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey,),
          ),
        ),
      ],
    );
  }
}
