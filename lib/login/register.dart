import 'package:flutter/material.dart';
import 'package:tapmetoremember/constants.dart';

import '../main.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
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
              padding:  EdgeInsets.all(8.0),
              child:  Text("Register"),
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
                  suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.visibility_off)),
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
                  hintText: 'Confirm Password',
                  suffixIcon: IconButton(onPressed: (){
                    
                  }, icon: const Icon(Icons.visibility_off)),
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
                        builder: (context) => MyHomePage(title: 'TapMe'),
                      ),
                    );
                  },
                  child:  Text("New User?",style: TextStyle(color: AppConstants().blue),)),
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
                  child: Text("Forgar Password ?",style: TextStyle(color: AppConstants().grey))),
            )
            ],)
          ]),
        ),
      ),
    );
  }
}