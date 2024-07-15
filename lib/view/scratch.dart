import 'package:flutter/material.dart';
import 'package:flutter_login/view/home.dart';
import 'package:flutter_login/viewmodel/FirebaseService.dart';
import 'dart:math';
import 'package:scratcher/scratcher.dart';

class Scratch extends StatefulWidget {
  const Scratch({super.key});

  @override
  State<Scratch> createState() => _ScratchState();
}

class _ScratchState extends State<Scratch> {
  int _score = 0;
  int random = Random().nextInt(21) + 10;
  final FirebaseService _firebaseService = FirebaseService();
  int scratch_score = 0;

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
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/bg.png'), // Đường dẫn đến hình ảnh của bạn
              fit: BoxFit.cover, // Cách hiển thị hình ảnh trong container
            ),
          ),
          child: Column(
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
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  height: 300,
                  width: 300,
                  child: Scratcher(
                    color: Colors.blueGrey,
                    threshold: 70,
                    onScratchEnd: () {
                      setState(() {
                        // Generate a random score between 10 and 30
                        scratch_score += random; // Lấy điểm từ Spin
                        updateScore(_score + scratch_score);
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
                                        "Your get score: $scratch_score",
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
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/bg_yellow.png',
                          fit: BoxFit.cover,
                          height: 300,
                        ),
                        Center(
                          child: Text(
                            '$random',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
