import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/user.dart';
import 'package:flutter_login/view/login.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<User?> get currentUser async => _firebaseAuth.currentUser;

// Đăng ký người dùng
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential? userCredential;

    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy thông tin người dùng mới tạo
      User? user = userCredential.user;

      if (user != null) {
        // Tạo đối tượng Users với thông tin người dùng
        Users newUser = Users(
          email: email,
          password: password,
          score: 0, // Khởi tạo điểm số ban đầu là 0
        );

        // Thêm dữ liệu vào Realtime Database
        final databaseRef = FirebaseDatabase.instance.ref('user/${user.uid}');
        await databaseRef.set(newUser.toJson());
      } else {
        // Xử lý trường hợp user là null
        print('Error: user object is null');
      }
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }

    return userCredential;
  }

  // Đăng nhập người dùng
  signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in user: $e');
      rethrow;
    }

    return UserCredential;
  }

  // Đăng xuất người dùng
  Future<void> signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      print('Error signing out user: $e');
      rethrow;
    }
  }
}

Future<int> showScore() async {
  late DatabaseReference _databaseRef;
  int _score = 0;

  try {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _databaseRef =
          FirebaseDatabase.instance.ref('user/${currentUser.uid}/score');
      DataSnapshot snapshot = await _databaseRef.get();
      if (snapshot.value != null) {
        _score = snapshot.value as int;
        return _score;
      } else {
        return 0; // Nếu không có điểm số, trả về 0
      }
    } else {
      return 0; // Nếu không có người dùng hiện tại, trả về 0
    }
  } catch (e) {
    print('Error getting score: $e');
    rethrow;
  }
}

Future<void> updateScore(int score) async {
  User? currentUser = await FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await FirebaseDatabase.instance
        .ref('user/${currentUser.uid}/score')
        .set(score);
  }
}
