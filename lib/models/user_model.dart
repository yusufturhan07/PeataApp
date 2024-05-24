class UserModel {
  final String email;
  final String displayName;
  final String userID;
  final String userToken;

  UserModel(
      {required this.email,
      required this.displayName,
      required this.userID,
      required this.userToken});
}
