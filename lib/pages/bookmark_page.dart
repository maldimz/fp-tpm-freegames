import 'package:flutter/material.dart';
import 'package:fp_games/model/games_model.dart';
import 'package:fp_games/routes/router_name.dart';
import 'package:fp_games/service/games_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late int _userId;
  String _update = "";

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    setState(() {
      _userId = userId!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
    _userId = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark'),
      ),
      body: FutureBuilder(
        future: gamesDatabaseHelper.getGamesByUserId(_userId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No Data'),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data[index].thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].shortDescription),
                    onTap: () async {
                      var hitPop =
                          await Navigator.pushNamed(context, RouterName.detail,
                              arguments: GamesModel(
                                thumbnail: snapshot.data[index].thumbnail,
                                shortDescription:
                                    snapshot.data[index].shortDescription,
                                id: snapshot.data[index].gamesId,
                                title: snapshot.data[index].title,
                                gameUrl: snapshot.data[index].gameUrl,
                                genre: snapshot.data[index].genre,
                                platform: snapshot.data[index].platform,
                                publisher: snapshot.data[index].publisher,
                                developer: snapshot.data[index].developer,
                                releaseDate: snapshot.data[index].releaseDate,
                                freetogameProfileUrl:
                                    snapshot.data[index].freetogameProfileUrl,
                              ));
                      setState(() {
                        _update = "";
                      });
                    },
                  );
                });
          }
        },
      ),
    );
  }
}
