import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_login/view/home.dart';
import 'package:flutter_login/viewmodel/FirebaseService.dart';
import 'package:rxdart/rxdart.dart';

class Spin extends StatefulWidget {
  const Spin({super.key});

  @override
  State<Spin> createState() => _SpinState();
}

class _SpinState extends State<Spin> {
  final selected = BehaviorSubject<int>();
  int _score = 0;
  int spin_score = 0;

  List<int> items = [10, 20, 50, 70, 100];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    int score = await showScore();
    setState(() {
      _score = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/bg.png'), // Đường dẫn đến hình ảnh của bạn
            fit: BoxFit.cover, // Cách hiển thị hình ảnh trong container
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 120,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0x23969AB2), // 14% opacity
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/coin.png', height: 30, width: 30),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$_score',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )),
              Spacer(),
              Container(
                height: 300,
                child: FortuneWheel(
                  selected: selected.stream,
                  animateFirst: false,
                  items: [
                    for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                      FortuneItem(child: Text(items[i].toString()))
                    }
                  ],
                  onAnimationEnd: () {
                    setState(() {
                      spin_score = items[selected.value]; // Lấy điểm từ Spin
                      updateScore(_score + spin_score);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/win.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Your get score: $spin_score",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home()));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation:
                                                8.0, // Thêm shadow cho button
                                            shadowColor: Colors.grey.withOpacity(
                                                0.5), // Chọn màu shadow và độ mờ
                                            backgroundColor: Colors
                                                .orangeAccent, // Thêm màu nền xanh dương cho button
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12.0), // Tạo bo góc cho button
                                            ),
                                          ),
                                          child: Text(
                                            "Home",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected.add(Fortune.randomInt(0, items.length));
                  });
                },
                child: Container(
                  height: 40,
                  width: 120,
                  color: Colors.redAccent,
                  child: Center(child: Text("Spin")),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
