class User {
  String userId;
  String username;
  String? email;
  late double productivityScore;

  User({
    required this.userId,
    required this.username,
    this.email,
  });
}
