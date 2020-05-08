import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/arena.dart';

class ArenaList extends StatefulWidget {
  @override
  _ArenaListState createState() => _ArenaListState();
}

class _ArenaListState extends State<ArenaList> {
  @override
  Widget build(BuildContext context) {
    final arenas = Provider.of<List<Arena>>(context) ?? [];

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 56),
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: arenas == null ? 0 : arenas.length,
      itemBuilder: (BuildContext context, int index) {
        Arena arena = arenas[index];

        return GestureDetector(
            onTap: () {
              Navigator.pop(context, arena);
            },
            child: SlideItem(
              img:
                  "https://i.pinimg.com/originals/7d/72/a7/7d72a781aabdb5c67b14ae3856a3772b.jpg",
              title: arena.name,
              address: arena.location,
            ));
      },
    );
  }
}

class SlideItem extends StatefulWidget {
  final String img;
  final String title;
  final String address;

  SlideItem({
    Key key,
    @required this.img,
    @required this.title,
    @required this.address,
  }) : super(key: key);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      child: Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3.7,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        "${widget.img}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text(
                  widget.title,
                  style: titleTextStyle,
                ),
                subtitle: Text(widget.address),
                trailing: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      MapsLauncher.launchQuery(widget.address);
                    },
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final TextStyle titleTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
