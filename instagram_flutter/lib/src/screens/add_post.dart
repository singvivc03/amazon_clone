import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/src/models/user.dart' as model;
import 'package:instagram_flutter/src/providers/user_provider.dart';
import 'package:instagram_flutter/src/resources/firestore_methods.dart';
import 'package:instagram_flutter/src/resources/util.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final TextEditingController _textEditingController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String result = await FireStoreMethods().uploadPost(_textEditingController.text, _file!, uid, username, profileImage);
      if (result == 'success') {
        setState(() {
          _isLoading = false;
        });
        if (context.mounted) {
          showSnackBar('Posted', context);
        }
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(result, context);
        }
      }
    } catch (err) {
      if (context.mounted) {
        showSnackBar(err.toString(), context);
      }
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a photo'),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.camera,);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery,);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final model.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null ? Center(
      child: IconButton(
          onPressed: () => _selectImage(context),
          icon: const Icon(Icons.upload),
      ),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('Post to'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(user.uid, user.username, user.photoUrl),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _isLoading ?
            const LinearProgressIndicator() :
            const Padding(
              padding: EdgeInsets.only(top: 0),
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      )
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          )
        ],
      ),
    );
  }
}
