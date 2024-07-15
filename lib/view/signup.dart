import 'package:flutter/material.dart';
import 'package:flutter_login/view/home.dart';
import 'package:flutter_login/view/login.dart';
import 'package:flutter_login/viewmodel/FirebaseService.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final auth = FirebaseService();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Image.asset('assets/login.png', height: 150, width: 150),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 300,
                  child: Text(
                    "Wellcome To Tricky Tiles Game!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 55, left: 55),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xfff3f3f3)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _email,
                        style: TextStyle(
                          fontSize: 19,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                          prefixIcon: Image.asset('assets/user.png',
                              width: 10, height: 10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 55, left: 55),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xfff3f3f3)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        obscureText: true,
                        controller: _password,
                        style: TextStyle(
                          fontSize: 19,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          border: InputBorder.none,
                          prefixIcon: Image.asset('assets/password.png',
                              width: 10, height: 10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 50),
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      final user = await auth.registerWithEmailAndPassword(
                        _email.text,
                        _password.text,
                      );
                      if (user != null) {
                        print('Sign up successful!');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      } else {
                        print('Sign up failed.');
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Color.fromARGB(255, 31, 155, 89),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Signup",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "have a account? ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 200, 209, 255),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
