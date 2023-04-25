import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tapmetoremember/constants.dart';
import 'package:tapmetoremember/login/register.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    checkForLogin();
    super.initState();
  }
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
      await _auth.signInWithEmailAndPassword(email: email!, password: password!);
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
          debugPrint(user.uid);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: size.width,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Login"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.visibility_off)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'TapMe'),
                      ),
                    );
                  },
                  child: const Text("Submit")),
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
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "New User?",
                        style: TextStyle(color: AppConstants().blue),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(title: 'TapMe'),
                          ),
                        );
                      },
                      child: startauthentication == false
                          ? Text("Forgar Password ?",
                              style: TextStyle(color: AppConstants().grey))
                          : const CircularProgressIndicator()),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
