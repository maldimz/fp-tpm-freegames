class GamesModel {
  int? id;
  String? title;
  int? gamesId;
  String? thumbnail;
  String? shortDescription;
  String? gameUrl;
  String? genre;
  String? platform;
  String? publisher;
  String? developer;
  String? releaseDate;
  String? freetogameProfileUrl;

  GamesModel({
    this.id,
    this.title,
    this.gamesId,
    this.thumbnail,
    this.shortDescription,
    this.gameUrl,
    this.genre,
    this.platform,
    this.publisher,
    this.developer,
    this.releaseDate,
    this.freetogameProfileUrl,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['thumbnail'] = thumbnail;
    map['short_description'] = shortDescription;
    map['game_url'] = gameUrl;
    map['genre'] = genre;
    map['platform'] = platform;
    map['publisher'] = publisher;
    map['developer'] = developer;
    map['release_date'] = releaseDate;
    map['freetogame_profile_url'] = freetogameProfileUrl;
    return map;
  }

  GamesModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    title = map['title'];
    gamesId = map['gamesId'];
    thumbnail = map['thumbnail'];
    shortDescription = map['shortDescription'];
    gameUrl = map['gameUrl'];
    genre = map['genre'];
    platform = map['platform'];
    publisher = map['publisher'];
    developer = map['developer'];
    releaseDate = map['releaseDate'];
    freetogameProfileUrl = map['freetogameprofileUrl'];
  }

  factory GamesModel.fromJson(Map<String, dynamic> json) => GamesModel(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        shortDescription: json["short_description"],
        gameUrl: json["game_url"],
        genre: json["genre"],
        platform: json["platform"],
        publisher: json["publisher"],
        developer: json["developer"],
        releaseDate: json["release_date"],
        freetogameProfileUrl: json["freetogame_profile_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "short_description": shortDescription,
        "game_url": gameUrl,
        "genre": genre,
        "platform": platform,
        "publisher": publisher,
        "developer": developer,
        "release_date": releaseDate,
        "freetogame_profile_url": freetogameProfileUrl,
      };
}
