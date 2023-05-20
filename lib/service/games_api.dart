import 'dart:convert';

import 'package:fp_games/model/games_model.dart';
import 'package:http/http.dart' as http;

class GamesApi {
  Future<List<GamesModel>> fetchGames() async {
    var url = Uri.parse('https://www.freetogame.com/api/games');
    var response = await http.get(url);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<GamesModel> games = [];
    for (var item in data) {
      if (data != null) {
        var game = GamesModel.fromJson(item);
        games.add(game);
      }
    }
    return games;
  }
}
