import 'package:flutter/material.dart';
import 'package:fp_games/model/games_model.dart';
import 'package:fp_games/routes/router_name.dart';
import 'package:fp_games/service/games_api.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  int _listLength = 10;
  late int _totalGames;
  ScrollController _scrollController = new ScrollController();
  String search = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          if (_listLength < _totalGames) {
            if (_listLength + 10 < _totalGames) {
              _listLength += 10;
            } else {
              _listLength = _totalGames;
            }
          }
        });
      }
    });
  }

  final GamesApi _gamesApi = GamesApi();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search Games',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _gamesApi.fetchGames(),
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
                _totalGames = snapshot.data.length;
                if (_listLength > _totalGames) {
                  _listLength = _totalGames;
                }

                if (search != "") {
                  List<GamesModel> _searchList = [];
                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (snapshot.data[i].title
                        .toLowerCase()
                        .contains(search.toLowerCase())) {
                      _searchList.add(snapshot.data[i]);
                    }
                  }

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _searchList.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage(_searchList[index].thumbnail!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(_searchList[index].title!),
                        subtitle: Text(_searchList[index].shortDescription!),
                        onTap: () {
                          Navigator.pushNamed(context, RouterName.detail,
                              arguments: GamesModel(
                                thumbnail: _searchList[index].thumbnail,
                                shortDescription:
                                    _searchList[index].shortDescription,
                                id: _searchList[index].id,
                                title: _searchList[index].title,
                                gameUrl: _searchList[index].gameUrl,
                                genre: _searchList[index].genre,
                                platform: _searchList[index].platform,
                                publisher: _searchList[index].publisher,
                                developer: _searchList[index].developer,
                                releaseDate: _searchList[index].releaseDate,
                                freetogameProfileUrl:
                                    _searchList[index].freetogameProfileUrl,
                              ));
                        },
                      );
                    },
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _listLength,
                  controller: _scrollController,
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
                      onTap: () {
                        Navigator.pushNamed(context, RouterName.detail,
                            arguments: GamesModel(
                              thumbnail: snapshot.data[index].thumbnail,
                              shortDescription:
                                  snapshot.data[index].shortDescription,
                              id: snapshot.data[index].id,
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
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
