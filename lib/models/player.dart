class Player {
  static const String idRef = 'id';
  static const String nameRef = 'name';
  static const String styleRef = 'style';
  static const String matchPlayedRef = 'matchPlayed';
  static const String pictureUrlRef = 'pictureUrl';
  static const String matchIdsRef = 'matchIds';

  static const String tireur = 'Tireur';
  static const String pointeur = 'Pointeur';

  final String id;
  String name;
  String style;
  final int matchPlayed;
  String pictureUrl;
  var matchIds= [];

  Player({this.id, this.name, this.style, this.matchPlayed, this.pictureUrl, this.matchIds});
}
