import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapmetoremember/constants.dart';
import 'package:tapmetoremember/login/login.dart';

import '../controllers/loginController.dart';
import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = !Get.isRegistered<LoginController>()
        ? Get.put(LoginController())
        : Get.find<LoginController>();
    var size = MediaQuery.of(context).size;
    final _auth = FirebaseAuth.instance;

    bool showSpinner = false;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: size.width,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Register"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: loginController.emailController,
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
                controller: loginController.passwordController,
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
              child: TextField(
                controller: loginController.confirmpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
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
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      // ignore: unrelated_type_equality_checks
                      if (loginController.confirmpasswordController.text ==
                          loginController.passwordController.text) {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: loginController.emailController.text,
                                password:
                                    loginController.passwordController.text);
                        if (newUser != null) {
                          debugPrint("Account Created");
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      } else {
                        var snackdemo = const SnackBar(
                          content: Text("Password Not Match"),
                          backgroundColor: Colors.green,
                          elevation: 10,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(5),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                      }
                    } catch (e) {
                      debugPrint("account exception $e");
                      debugPrint("Account Login $e");
                      var snackdemo = SnackBar(
                        content: Text(e.toString().split(']')[1]),
                        backgroundColor: Colors.green,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                    }
                    setState(() {
                      showSpinner = false;
                    });
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
                            builder: (context) => MyHomePage(title: 'TapMe'),
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
                      child: Text("Forgar Password ?",
                          style: TextStyle(color: AppConstants().grey))),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
