import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/models/user.dart';
import 'package:tirelebut/services/database-player.dart';
import 'package:tirelebut/shared/loading.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _image;
  var colorTeal = Colors.teal;

  @override
  Widget build(BuildContext context) {
    /**
     *
     */
    final nameController = TextEditingController();
    /**
     *
     */
    final styleController = TextEditingController();
    /**
     *
     */
    User user = Provider.of<User>(context);

    /**
     *
     */
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    /**
     *
     */
    Future saveUser(BuildContext context, Player player) async {
      if (_image != null) {
        String fileName = basename(_image.path);
        StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        var url = await taskSnapshot.ref.getDownloadURL();
        player.pictureUrl = url.toString();
      }

      if (styleController.text.isNotEmpty) player.style = styleController.text;
      if (nameController.text.isNotEmpty) player.name = nameController.text;

      await DatabaseServicePlayer(uid: user.uid).updateUserData(
          player.name, player.style, player.matchPlayed, player.pictureUrl, player.matchIds);
      setState(() {
        print("Profile uploaded");
//        Scaffold.of(context)
//            .showSnackBar(SnackBar(content: Text('Profile Uploaded')));
        Navigator.of(context).pop();
      });
    }

    return StreamBuilder<Player>(
        stream: DatabaseServicePlayer(uid: user.uid).user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Player player = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                  title: Text('Edit Profile'),
                  backgroundColor: Colors.teal,
                  actions: <Widget>[
                    // action button
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        saveUser(context, player);
                      },
                    ),
                  ]),
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.teal,
                                  child: CircleAvatar(
                                    radius: 95,
                                    backgroundImage: (_image != null)
                                        ? Image.file(
                                            _image,
                                            fit: BoxFit.fill,
                                          )
                                        : NetworkImage(
                                            player.pictureUrl,
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 60.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_enhance,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ]),
                        Divider(
                          color: Colors.white,
                          height: 60.0,
                        ),
                        Text(
                          'NAME',
                          style: TextStyle(
                            color: colorTeal[80],
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${player.name}',
                          ),
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          'GAME STYLE',
                          style: TextStyle(
                            color: colorTeal[80],
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: styleController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${player.style}',
                          ),
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: 60.0),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
