import 'package:flutter/material.dart';
import 'package:instagram_flutter/src/models/user.dart';
import 'package:instagram_flutter/src/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final document;

  const CommentCard({super.key, required this.document});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16,),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.document['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.document['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      TextSpan(
                        text: ' ${widget.document['text']}',
                      ),
                    ]
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 4),
                    child: Text(DateFormat.yMMMd().format(widget.document['datePublished'].toDate()), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite, size: 16,),
          ),
        ],
      ),
    );
  }
}
