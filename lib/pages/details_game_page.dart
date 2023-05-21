import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_games/model/detail_games_model.dart';
import 'package:fp_games/model/games_model.dart';
import 'package:fp_games/service/detail_games_api.dart';
import 'package:fp_games/service/games_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailGamePage extends StatefulWidget {
  final GamesModel? gamesModel;
  DetailGamePage({Key? key, this.gamesModel}) : super(key: key);

  @override
  State<DetailGamePage> createState() => _DetailGamePageState();
}

class _DetailGamePageState extends State<DetailGamePage> {
  final DetailGamesApi _detailGamesApi = DetailGamesApi();
  late bool _isBookmark;
  late int userId;
  late int _dbId;

  Future<void> _getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    setState(() {
      this.userId = userId!;
    });
    var list = await gamesDatabaseHelper.getGamesByUserId(userId!);
    if (list.any((element) => element.gamesId == widget.gamesModel!.id)) {
      for (var item in list) {
        if (item.gamesId == widget.gamesModel!.id) {
          setState(() {
            _dbId = item.id!;
          });
        }
      }
      setState(() {
        _isBookmark = true;
      });
    } else {
      setState(() {
        _isBookmark = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isBookmark = false;
    userId = 0;
    _dbId = 0;
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.gamesModel!.title!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              )),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isBookmark = !_isBookmark;
                });
                if (_isBookmark) {
                  gamesDatabaseHelper.createGame(widget.gamesModel!, userId);
                } else {
                  gamesDatabaseHelper.deleteGame(_dbId);
                }
              },
              icon: Icon(_isBookmark ? Icons.bookmark : Icons.bookmark_border),
            ),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: widget.gamesModel!.gameUrl!));
                final snackBar = SnackBar(
                  content: Text('Link Copied'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: ''));
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(Icons.share),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _detailGamesApi.fetchDetailGames(widget.gamesModel!.id!),
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
              DetailGamesModel _detailGamesModel = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(_detailGamesModel.thumbnail!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Center(
                                child: Text(
                              _detailGamesModel.genre!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse(_detailGamesModel.gameUrl!));
                                  },
                                  child: Text('Play Now')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // decs
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'About ${_detailGamesModel.title!}',
                        style: _titleDetailStyle,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        _detailGamesModel.description!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // screenshot
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'Screenshot',
                        style: _titleDetailStyle,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: _detailGamesModel.screenshots!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image(
                                image: NetworkImage(_detailGamesModel
                                    .screenshots![index].image!)),
                          );
                        },
                      ),
                    ),
                    // information
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'Additional Information',
                        style: _titleDetailStyle,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          _aditionalText(
                              "Dvelopers", _detailGamesModel.developer!),
                          SizedBox(height: 5),
                          _aditionalText(
                              "Publishers", _detailGamesModel.publisher!),
                          SizedBox(height: 5),
                          _aditionalText(
                              "Release Date", _detailGamesModel.releaseDate!),
                          SizedBox(height: 5),
                          _aditionalText(
                              "Platforms", _detailGamesModel.platform!),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    // system
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'Minimum System Requirements (${_detailGamesModel.platform!})',
                        style: _titleDetailStyle,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _systemColumn('OS',
                              _detailGamesModel.minimumSystemRequirements!.os!),
                          SizedBox(height: 10),
                          _systemColumn(
                              'Processor',
                              _detailGamesModel
                                  .minimumSystemRequirements!.processor!),
                          SizedBox(height: 10),
                          _systemColumn(
                              'Memory',
                              _detailGamesModel
                                  .minimumSystemRequirements!.memory!),
                          SizedBox(height: 10),
                          _systemColumn(
                              'Graphics',
                              _detailGamesModel
                                  .minimumSystemRequirements!.graphics!),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}

TextStyle _titleDetailStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

Row _aditionalText(String title, String content) => Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
Column _systemColumn(String title, String content) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
