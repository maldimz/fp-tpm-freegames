import 'package:flutter/material.dart';
import 'package:fp_games/model/games_model.dart';
import 'package:fp_games/pages/bookmark_page.dart';
import 'package:fp_games/pages/details_game_page.dart';
import 'package:fp_games/pages/home_page.dart';
import 'package:fp_games/pages/login_page.dart';
import 'package:fp_games/pages/register_page.dart';
import 'package:fp_games/pages/upgrade_page.dart';
import 'package:fp_games/routes/router_name.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.login:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case RouterName.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());

      case RouterName.homepage:
        return MaterialPageRoute(builder: (_) => HomePage());

      case RouterName.detail:
        final args = settings.arguments as GamesModel;
        return MaterialPageRoute(
            builder: (_) => DetailGamePage(
                  gamesModel: args,
                ));

      case RouterName.bookmark:
        return MaterialPageRoute(builder: (_) => BookmarkPage());

      case RouterName.upgrade:
        return MaterialPageRoute(builder: (_) => UpgradePage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text('Error page')),
      );
    });
  }
}
