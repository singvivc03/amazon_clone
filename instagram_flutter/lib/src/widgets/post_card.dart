import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:instagram_flutter/src/models/user.dart" as model;
import "package:instagram_flutter/src/providers/user_provider.dart";
import "package:instagram_flutter/src/resources/firestore_methods.dart";
import "package:instagram_flutter/src/resources/util.dart";
import "package:instagram_flutter/src/screens/comment_screen.dart";
import "package:instagram_flutter/src/widgets/like_animation.dart";
import "package:instagram_flutter/utils/colors.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class PostCard extends StatefulWidget {

  final document;

  const PostCard({super.key, required this.document});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int numberOfComments = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts')
          .doc(widget.document['postId']).collection('comments').get();
      numberOfComments = querySnapshot.docs.length;
    } catch (err) {
      if (mounted) {
        showSnackBar(err.toString(), context);
      }
    }
    setState(() {});
  }

  void deletePost() async {
    try {
      await FireStoreMethods().deletePost(widget.document['postId']);
    } catch (err) {
      if (mounted) {
        showSnackBar(err.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.document['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.document['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      deletePost();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().upVote(widget.document['postId'], user.uid, widget.document['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: double.infinity,
                  child: Image.network(widget.document['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite, color: Colors.white, size: 80,),
                  ),
                ),
              ],
            ),
          ),

          // Like, comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.document['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().upVote(widget.document['postId'], user.uid, widget.document['likes']);
                  },
                  icon: widget.document['likes'].contains(user.uid) ? const Icon(Icons.favorite, color: Colors.red,) :
                    const Icon(Icons.favorite_border,),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(
                  document: widget.document,
                ),),),
                icon: const Icon(Icons.comment_outlined,),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send,),),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                )
              ),
            ],
          ),

          // Description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
                  child: Text('${widget.document['likes'].length} likes', style: Theme.of(context).textTheme.bodyMedium,),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.document['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text: ' ${widget.document['description']}',
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                      ]
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('View all $numberOfComments comments', style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(DateFormat.yMMMd().format(widget.document['datePublished'].toDate(),), style: const TextStyle(
                    fontSize: 16,
                    color: secondaryColor,
                  ),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
