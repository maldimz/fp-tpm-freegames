import 'package:fp_games/model/review_model.dart';
import 'package:fp_games/service/database_helper.dart';

class ReviewDatabaseHelper {
  static String tableName = 'Reviews';

  static Future<void> createReview(ReviewModel review) async {
    final db = await DatabaseHelper.instance.database;
    await db!.insert(tableName, review.toMap());
  }

  static Future<List<ReviewModel>> getReviews() async {
    final db = await DatabaseHelper.instance.database;
    List<Map> list = await db!.rawQuery(
        'SELECT * FROM $tableName JOIN User ON Reviews.userId = User.id');

    List<ReviewModel> reviews = [];

    for (var item in list) {
      var review = ReviewModel.fromMap(item);
      reviews.add(review);
    }
    return reviews;
  }

  static Future<void> updateReview(ReviewModel review) async {
    final db = await DatabaseHelper.instance.database;
    await db!.update(tableName, review.toMap(),
        where: 'id = ?', whereArgs: [review.id]);
  }

  static Future<void> deleteReview(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
