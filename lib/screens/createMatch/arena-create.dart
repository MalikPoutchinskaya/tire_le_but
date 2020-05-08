import 'package:flutter/material.dart';
import 'package:tirelebut/models/arena.dart';
import 'package:tirelebut/services/database-arena.dart';

class ArenaCreateScreen extends StatefulWidget {
  @override
  _HomeMaterialState createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State {
  final _formKey = GlobalKey<FormState>();
  final _arena = Arena();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New arena'), backgroundColor: Colors.teal,),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Builder(
              builder: (context) => Form(
                  key: _formKey,
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an arena name';
                            }
                          },
                          onSaved: (val) => setState(() => _arena.name = val),
                        ),
                        TextFormField(
                            decoration: InputDecoration(labelText: 'Location'),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an arena location;';
                              }
                            },
                            onSaved: (val) =>
                                setState(() => _arena.location = val)),
                      ])))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            await DatabaseServiceArena().create(_arena);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
