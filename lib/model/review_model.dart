class ReviewModel {
  int? id;
  int? userId;
  String? review;
  String? username;

  ReviewModel({
    this.id,
    required this.userId,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['review'] = review;
    return map;
  }

  ReviewModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    username = map['username'];
    review = map['review'];
  }
}
