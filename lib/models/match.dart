import 'arena.dart';

class Match {
  static const String idRef = 'id';
  static const String nameRef = 'name';
  static const String dateRef = 'date';
  static const String timeRef = 'time';
  static const String totalSlotsRef = 'total_slots';
  static const String slotsBookedRef = 'slots_booked';
  static const String arenaRef = 'arena';
  static const String ownerIdRef = 'owner_id';
  static const String playerIdsRef = 'playerIds';

  final String id;
  String name;
  int date;
  String time;
  int totalSlots;
  int slotsBooked;
  Arena arena;
  String ownerId;
  List<String> playerIds;

  bool isMatchComplete() {
    return totalSlots <= playerIds.length;
  }


  Match({this.id,
    this.name,
    this.date,
    this.time,
    this.totalSlots,
    this.slotsBooked,
    this.arena,
    this.ownerId,
    this.playerIds});
}
