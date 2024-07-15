import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/model/user.dart';
import 'package:flutter_login/view/game.dart';
import 'package:flutter_login/view/scratch.dart';
import 'package:flutter_login/view/spin.dart';
import 'package:flutter_login/viewmodel/FirebaseService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseService();

  final FirebaseService _firebaseService = FirebaseService();

  int _score = 0;

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          auth.signOut(context);
                        },
                        child: Image.asset('assets/setting.png',
                            height: 40, width: 40)),
                    Spacer(),
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
                              Image.asset('assets/coin.png',
                                  height: 30, width: 30),
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
                        ))
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Spin()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 178, 155), //
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 90, 90, 90)
                                      .withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/spin.png',
                                        height: 40, width: 40),
                                  ],
                                ),
                              ],
                            )),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scratch()));
                          },
                          child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 255, 178, 155), // 14% opacity
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 90, 90, 90)
                                        .withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/scratch.png',
                                          height: 40, width: 40),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TrickyTiles()));
                  },
                  child: Container(
                    width: 200,
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/trickytiles.png'), // Đường dẫn đến hình ảnh của bạn
                          fit: BoxFit
                              .cover, // Cách hiển thị hình ảnh trong container
                        ),
                        border: Border.all(
                          color: Color(0xffFFF2F2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                            width: 130,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 145, 0),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 90, 90, 90)
                                      .withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/play.png',
                                        height: 40, width: 40),
                                    Text(
                                      "Play",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
