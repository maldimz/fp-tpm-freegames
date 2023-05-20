import 'package:flutter/material.dart';
import 'package:fp_games/model/review_model.dart';
import 'package:fp_games/service/review_database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late int _userId;

  final TextEditingController _reviewController = TextEditingController();

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
    _userId = 0;
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Review of Mobile Technology',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Enter your review',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var message = "Review Submitted";
                      final SnackBar snackBar = SnackBar(
                        content: Text(message),
                      );
                      if (_reviewController.text == "") {
                        message = "Review cannot be empty";
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      var review = _reviewController.text;
                      await ReviewDatabaseHelper.createReview(ReviewModel(
                        userId: _userId,
                        review: review,
                      ));

                      setState(() {
                        _reviewController.text = '';
                      });

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: ReviewDatabaseHelper.getReviews(),
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
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].username),
                          subtitle: Text(snapshot.data[index].review),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
