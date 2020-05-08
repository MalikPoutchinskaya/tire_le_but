class Arena {
  static const String idRef = 'id';
  static const String nameRef = 'name';
  static const String locationRef = 'location';

  final String id;
  String name;
  String location;

  Arena({this.id, this.name, this.location});

  Map<String, dynamic> toJson() =>
      {
        idRef: id,
        nameRef: name,
        locationRef:location
      };
}
