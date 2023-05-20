import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tapmetoremember/constants.dart';
import 'package:tapmetoremember/login/register.dart';

import '../controllers/loginController.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final LoginController loginController = !Get.isRegistered<LoginController>()
    ? Get.put(LoginController())
    : Get.find<LoginController>();

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    startTimer();
    checkForLogin();
    super.initState();
  }

  late Timer _timer;
  int start = 0;
  late StreamController streamController;
  void startTimer() {
    const oneSec = Duration(seconds: 3);
    streamController = StreamController<int>();
    _timer = Timer.periodic(oneSec, (Timer timer) {
      streamController.sink.add(start);
      loginController.isMale = !loginController.isMale;
      if (loginController.isMale) {
        setState(() {
          title = loginController.maleHead;
        });
      } else {
        setState(() {
          title = loginController.femaleHead;
        });
      }
    });
  }

  String title = loginController.femaleHead;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  Future signUp({String? emailid, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailid!,
        password: password!,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  var startauthentication = false;
  checkForLogin() {
    setState(() {
      startauthentication = true;
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
        setState(() {
          startauthentication = false;
        });
      } else {
        debugPrint('User is signed in!');
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null) {
            debugPrint("Already Llogged in${user.uid}");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: 'TapMe'),
              ),
            );
          }
        });
        setState(() {
          startauthentication = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final _auth = FirebaseAuth.instance;

    return Scaffold(
        body: Container(
            height: size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromARGB(242, 218, 210, 198),
                  Color.fromARGB(255, 164, 241, 190),
                  Color.fromARGB(242, 218, 210, 198),
                ])),
            child: Stack(
              children: [
                Container(
                    height: size.height,
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        loginController.back,
                        fit: BoxFit.cover,
                      ),
                    )),
                SingleChildScrollView(
                  child: Center(
                    child: Column(children: [
                      SizedBox(
                        height: size.width / 1.5,
                      ),
                      AnimatedContainer(
                        width: size.width / 2,
                        height: size.width / 2,
                        // decoration: BoxDecoration(
                        //   color: loginController.color,
                        //   borderRadius: loginController.borderRadius,
                        // ),
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: Lottie.asset(title),
                      ),
                      SizedBox(
                        height: size.width / 20.5,
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text("Login"),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          controller: loginController.loginEmailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          controller: loginController.loginPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.visibility_off)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide:
                                    BorderSide(color: AppConstants().white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () async {
                              setState(() {
                                loginController.showSpinner = true;
                              });
                              try {
                                final user = await _auth
                                    .signInWithEmailAndPassword(
                                        email: loginController
                                            .loginEmailController.text,
                                        password: loginController
                                            .loginPasswordController.text);
                                if (user != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MyHomePage(title: 'TapMe'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint("Account Login $e");
                                var snackdemo = SnackBar(
                                  content: Text(e.toString().split(']')[1]),
                                  backgroundColor: Colors.green,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(5),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                              }
                              setState(() {
                                loginController.showSpinner = false;
                              });
                            },
                            child: loginController.showSpinner == true
                                ? looading()
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        color: AppConstants().white,
                                        fontSize: 20),
                                  )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "New User?",
                                  style: TextStyle(color: AppConstants().blue),
                                )),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextButton(
                          //       onPressed: () {
                          //         Navigator.of(context).push(
                          //           MaterialPageRoute(
                          //             builder: (context) => MyHomePage(title: 'TapMe'),
                          //           ),
                          //         );
                          //       },
                          //       child: startauthentication == false
                          //           ? Text("Forgar Password ?",
                          //               style: TextStyle(color: AppConstants().grey))
                          //           : const CircularProgressIndicator()),
                          // )
                        ],
                      )
                    ]),
                  ),
                )
              ],
            )));
  }

  Widget looading() {
    return SizedBox(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 7.0,
              color: Colors.white,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            FlickerAnimatedText('Loading...'),
          ],
        ),
      ),
    );
  }
}
