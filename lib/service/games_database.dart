import 'package:fp_games/model/games_model.dart';
import 'package:fp_games/service/database_helper.dart';

class gamesDatabaseHelper {
  static String tableName = 'Games';

  static Future<void> createGame(GamesModel game, int userId) async {
    final db = await DatabaseHelper.instance.database;
    Map<String, dynamic> toMap() {
      var map = <String, dynamic>{};
      map['userId'] = userId;
      map['gamesId'] = game.id;
      map['title'] = game.title;
      map['thumbnail'] = game.thumbnail;
      map['shortDescription'] = game.shortDescription;
      map['gameUrl'] = game.gameUrl;
      map['genre'] = game.genre;
      map['platform'] = game.platform;
      map['publisher'] = game.publisher;
      map['developer'] = game.developer;
      map['releaseDate'] = game.releaseDate;
      map['freetogameProfileUrl'] = game.freetogameProfileUrl;
      return map;
    }

    await db!.insert(tableName, toMap());
  }

  static Future<List<GamesModel>> getGames() async {
    final db = await DatabaseHelper.instance.database;
    List<Map> list = await db!.query('$tableName');

    List<GamesModel> games = [];

    for (var item in list) {
      var game = GamesModel.fromMap(item);
      games.add(game);
    }
    return games;
  }

  static Future<List<GamesModel>> getGamesByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    List<Map> list =
        await db!.query('$tableName', where: 'userId = ?', whereArgs: [userId]);

    List<GamesModel> games = [];

    for (var item in list) {
      var game = GamesModel.fromMap(item);
      games.add(game);
    }

    return games;
  }

  static Future<void> updateGame(GamesModel game) async {
    final db = await DatabaseHelper.instance.database;
    await db!
        .update(tableName, game.toMap(), where: 'id = ?', whereArgs: [game.id]);
  }

  static Future<void> deleteGame(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
