import 'package:flutter/material.dart';
import 'package:tirelebut/models/arena.dart';

class ArenaTitle extends StatelessWidget {
  final Arena arena;

  ArenaTitle({this.arena});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child:
        ListTile(
          leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.yellow[30],
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/originals/7d/72/a7/7d72a781aabdb5c67b14ae3856a3772b.jpg')),
          title: Text(arena.name),
          subtitle: Text('Arena id ${arena.id}'),
          onTap: () {
            Navigator.pop(context, arena);
          },
        ),
      ),
    );
  }
}
