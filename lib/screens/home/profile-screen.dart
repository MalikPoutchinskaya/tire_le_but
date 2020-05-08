import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/models/user.dart';
import 'package:tirelebut/screens/profile/edit_profile.dart';
import 'package:tirelebut/services/auth.dart';
import 'package:tirelebut/services/database-player.dart';
import 'package:tirelebut/shared/loading.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _HomeMaterialState createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State {
  final AuthService _auth = AuthService();


  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(choices[0].icon),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
          // overflow menu
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(1).map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: GestureDetector(
                      onTap: () async {
                        await _auth.signOut();
                      },
                      child: Text(choice.title),
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<Player>(
        stream: DatabaseServicePlayer(uid: user.uid).user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Player player = snapshot.data;
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundImage: NetworkImage(player.pictureUrl),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        height: 60.0,
                      ),
                      Text(
                        'NAME',
                        style: TextStyle(
                          color: Colors.teal[80],
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${player.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'GAME STYLE',
                        style: TextStyle(
                          color: Colors.teal[80],
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${player.style}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'MATCH PLAYED',
                        style: TextStyle(
                          color: Colors.teal[80],
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${player.matchPlayed}',
                        style: TextStyle(
                          color: Colors.white,
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
            );
          } else {
            return Loading();
          }
        });
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Edit', icon: Icons.edit),
  const Choice(title: 'Sign out', icon: Icons.pause_circle_outline),
];
