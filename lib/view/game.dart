import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/view/home.dart';
import 'package:flutter_login/viewmodel/FirebaseService.dart';

class TrickyTiles extends StatefulWidget {
  const TrickyTiles({super.key});

  @override
  State<TrickyTiles> createState() => _TrickyTilesState();
}

class Tile {
  final int num;
  Color color;
  bool isCorrect;

  Tile(this.num, this.color, {this.isCorrect = false});
}

final assetsAudioPlayer = AssetsAudioPlayer();

class _TrickyTilesState extends State<TrickyTiles> {
  List<Tile> grid = []; // [tile1, tile2, tile3, ...]
  int timeLeft = 30;
  Timer? timer;
  Color? correctColor;
  int score = 0;
  int score_fb = 0;
  int remaining = 0;
  final FirebaseService _firebaseService = FirebaseService();
  int gameStartTime = 0;

  @override
  void initState() {
    super.initState();
    setSound();
    gameStartTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    initializeGame();
    startTimer();
    _loadScore();
  }

  Future<void> _loadScore() async {
    int score = await showScore();
    setState(() {
      score_fb = score;
    });
  }

  Future<void> setSound() async {}

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initializeGame() {
    remaining = 0;

    // Randomly select a color for the tiles
    List<Color> colors = [Colors.red, Colors.green, Colors.yellow];

    List<Color> colorsGen = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.white
    ];
    List<Color> colorsGenWhite = [
      Colors.white,
      Colors.white,
      Colors.white,
    ];

    correctColor = colors[Random().nextInt(colors.length)];
    grid.clear();

    if (score < 10) {
      for (int i = 0; i < 9; i++) {
        grid.add(Tile(i, Colors.white));
      }
      int pos = Random().nextInt(9);
      grid[pos].color = correctColor!;
      grid[pos].isCorrect = true;
      remaining = 1;
    } else {
      for (int i = 0; i < 9; i++) {
        Color c = colorsGen[Random().nextInt(colorsGen.length)];
        if (c == correctColor) {
          grid.add(Tile(i, c, isCorrect: true));
          remaining++;
        } else {
          grid.add(Tile(i, c));
        }
      }
    }
    if (remaining == 0) initializeGame();
  }

  void onClick(Tile tile) {
    AssetsAudioPlayer.newPlayer()
        .open(Audio("assets/audio/click.wav"), autoStart: true);
    if (tile.color != correctColor && tile.isCorrect == false) {
      endGame();
    } else {
      setState(() {
        score++;
        if (remaining <= 1) {
          initializeGame(); // Start a new round
        } else {
          remaining = remaining - 1;
          grid[tile.num].color = Colors.white;
          grid[tile.num].isCorrect = false;
        }
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          endGame();
        }
      });
    });
  }

  void endGame() {
    // Game over logic here
    timer!.cancel();
    if (score != 0) {
      setState(() {
        updateScore(score_fb + score);
      });
      AssetsAudioPlayer.newPlayer()
          .open(Audio("assets/audio/done.wav"), autoStart: true);
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
                    "Your score get: $score",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8.0, // Thêm shadow cho button
                          shadowColor: Colors.grey
                              .withOpacity(0.5), // Chọn màu shadow và độ mờ
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrickyTiles()));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8.0, // Thêm shadow cho button
                          shadowColor: Colors.grey
                              .withOpacity(0.5), // Chọn màu shadow và độ mờ
                          backgroundColor: Colors
                              .orangeAccent, // Thêm màu nền xanh dương cho button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Tạo bo góc cho button
                          ),
                        ),
                        child: Text(
                          "Again",
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
        },
      );
    } else {
      AssetsAudioPlayer.newPlayer()
          .open(Audio("assets/audio/blast.wav"), autoStart: true);
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
                    "assets/lose.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Your score: $score",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8.0, // Thêm shadow cho button
                          shadowColor: Colors.grey
                              .withOpacity(0.5), // Chọn màu shadow và độ mờ
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrickyTiles(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8.0, // Thêm shadow cho button
                          shadowColor: Colors.grey
                              .withOpacity(0.5), // Chọn màu shadow và độ mờ
                          backgroundColor: Colors
                              .orangeAccent, // Thêm màu nền xanh dương cho button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Tạo bo góc cho button
                          ),
                        ),
                        child: Text(
                          "Again",
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
        },
      );
    }
  }

  String getColorName(Color color) {
    if (color == Colors.red) {
      return "RED";
    } else if (color == Colors.yellow) {
      return "YELLOW";
    } else if (color == Colors.green) {
      return "GREEN";
    } else {
      return "NAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double ratio = 0.21;

    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img1.jpg"),
                      fit: BoxFit.cover))),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black12,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                  aspectRatio: 1.0, // 1:1 aspect ratio
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Flexible(child: Container()),
                            Row(
                              children: [
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[0]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[0].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[1]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[1].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[2]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[2].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                              ],
                            ),
                            Flexible(child: Container()),
                            Row(
                              children: [
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[3]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[3].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[4]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[4].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[5]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[5].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                              ],
                            ),
                            Flexible(child: Container()),
                            Row(
                              children: [
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[6]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[6].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[7]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[7].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    onClick(grid[8]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: grid[8].color),
                                    height: screenWidth * ratio,
                                    width: screenWidth * ratio,
                                  ),
                                ),
                                Flexible(child: Container()),
                              ],
                            ),
                            Flexible(child: Container())
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Text("$timeLeft sec",
                  style: TextStyle(color: Colors.black87, fontSize: 30)),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(getColorName(correctColor!),
                        style: TextStyle(color: correctColor, fontSize: 50)),
                  ),
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Text("$score",
                  style: TextStyle(color: Colors.black, fontSize: 70)),
            ),
          )
        ],
      ),
    );
  }
}
