class Error {
  final int code;
  final String message;
  final String english;
  Error({required this.code, required this.message, required this.english});
  Map<String, dynamic> toJson() =>
      {'code': code, 'message': message, 'english': english};
}
