import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tirelebut/models/arena.dart';
import 'package:tirelebut/models/match.dart';
import 'package:tirelebut/models/player.dart';
import 'package:tirelebut/models/user.dart';
import 'package:tirelebut/services/database-match.dart';
import 'package:tirelebut/services/database-player.dart';

import 'arenas_screen.dart';

class MatchCreateScreen extends StatefulWidget {
  @override
  _HomeMaterialState createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State {
  final _formKey = GlobalKey<FormState>();
  final _match = Match();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController arenaCtl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Arena arenaSelected;
  List<String> typeNeg = [
    "2",
    "3",
    "4",
    "5",
    "6",
  ];

  String dropdownValue = "4";

  Future<Null> getArena(BuildContext context) async {
    arenaSelected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArenasScreen()),
    );
    arenaCtl.text = arenaSelected.name;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        dateCtl.text = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        final MaterialLocalizations localizations =
            MaterialLocalizations.of(context);
        timeCtl.text = localizations.formatTimeOfDay(picked);
        selectedTime = picked;
      });
  }

  String _getTimeReadable(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat("HH:mm").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<Player>(
        stream: DatabaseServicePlayer(uid: user.uid).user,
        builder: (context, snapshot) {
          Player player = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black87),
              elevation: 0,
              title: const Text('New creation',
                  style: TextStyle(color: Colors.black87)),
            ),
            body: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(15.0),
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xfff6f6f6),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none),
                                labelText: 'Match name',
                                hintText: 'Put a match name'),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a match name';
                              }
                            },
                            onSaved: (val) => setState(() => _match.name = val),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: IgnorePointer(
                              child: new TextFormField(
                                controller: dateCtl,
                                decoration: new InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xfff6f6f6),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    labelText: 'Match date',
                                    hintText: 'Select the match date'),
                                onSaved: (val) => setState(() => _match.date =
                                    selectedDate.millisecondsSinceEpoch),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: IgnorePointer(
                              child: new TextFormField(
                                controller: timeCtl,
                                decoration: new InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xfff6f6f6),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    labelText: 'Match time',
                                    hintText: 'Select the match time'),
                                onSaved: (val) => setState(() => _match.time =
                                    _getTimeReadable(selectedTime)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () async {
                              getArena(context);
                            },
                            child: IgnorePointer(
                              child: new TextFormField(
                                controller: arenaCtl,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xfff6f6f6),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    labelText: 'Arena',
                                    hintText: 'Pick an arena!'),
                                onSaved: (val) => setState(
                                    () => _match.arena = arenaSelected),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xfff6f6f6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                            ),
                            value: dropdownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            // ignore: missing_return
                            validator: (String value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter a valid number of players';
                              }
                            },
                            items: typeNeg
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onSaved: (val) => setState(
                                () => _match.totalSlots = int.parse(val)),
                          ),
                        ]))),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    var matchId =
                        await DatabaseServiceMatch().create(_match, player.id);
                    player.matchIds.add(matchId);
                    await DatabaseServicePlayer()
                        .updateUserDataWithPlayer(player);
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.check),
              ),
            ),
          );
        });
  }
}
