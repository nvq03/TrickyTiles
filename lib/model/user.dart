class Users {
  String? email;
  String? password;
  int? score;

  Users({this.email, this.password, this.score});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      email: json['email'],
      password: json['password'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'score': score,
    };
  }
}
