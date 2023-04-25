import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ToLCD extends StatefulWidget {
  const ToLCD({super.key});

  @override
  State<ToLCD> createState() => _ToLCDState();
}

class _ToLCDState extends State<ToLCD> {
  
  @override
  @override
  var data;
  TextEditingController message = TextEditingController();
  String messageData = "";
  @override
  void initState() {
    readData();
    super.initState();
  }
  void sendData(String value) async {
    await ref.update({
      "lcdmale": value,
    });
    setState(() {
      //sent PopUp Message
      const snackdemo = SnackBar(
        content: Text('Sent'),
        backgroundColor: Colors.green,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    });
  }
  var isLoading = false;
  void clearLcdData() async {
    setState(() {
      isLoading = true;
    });
    await ref.update({
      "lcdmale": "",
    });
    setState(() {
      //sent PopUp Message
      messageData = "";
      message.clear();
      const snackdemo = SnackBar(
        content: Text('Clear'),
        backgroundColor: Colors.green,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    });
    setState(() {
      isLoading = false;
    });
  }
    readData() async {
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {

        print('Event Type: ${event.type}');
        print('Snapshot: ${event.snapshot.value}');
        if (event.snapshot.child("lcdmale").value != "") {
          setState(() {
            message.text = event.snapshot.child("lcdmale").value.toString();
            messageData = event.snapshot.child("lcdmale").value.toString();
          });
        }
      });
      setState(() {
        data = "";
      });
  }


  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: message,
              obscureText: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      sendData(data);
                      setState(() {
                        messageData = data;
                      });
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    )),
                labelText: 'Message',
                hintText: 'Enter Message',
              ),
              onChanged: (value) {
                setState(() {
                  data = value;
                });
              },
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/lcd.png',
                width: size.width / 1.2,
                height: size.width,
              ),
              Text(messageData),
              messageData!=""?Padding(
                padding: EdgeInsets.only(right:size.width/10,bottom: size.width/2.5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        clearLcdData();
                      },
                      icon: const Icon(Icons.clear_rounded)),
                ),
              ):const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
