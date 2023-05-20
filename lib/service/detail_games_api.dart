import 'dart:convert';

import 'package:fp_games/model/detail_games_model.dart';
import 'package:http/http.dart' as http;

class DetailGamesApi {
  Future<DetailGamesModel> fetchDetailGames(int id) async {
    var url = Uri.parse('https://www.freetogame.com/api/game?id=$id');
    var response = await http.get(url);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    var detailGames = DetailGamesModel.fromJson(data);

    return detailGames;
  }
}
