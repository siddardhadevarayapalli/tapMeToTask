import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tapmetoremember/apicalls/apicalls.dart';

import '../../constants.dart';
import '../../main.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  var data;
  List<Widget> messagetextfields = [];
  TextEditingController message = TextEditingController();
  readData() async {
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}');
      print('Snapshot: ${event.snapshot.value}');
      if (event.snapshot.child(readSms).value != "") {
        setState(() {
          messagetextfields.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text("Their :${event.snapshot.child(readSms).value}"),
            ),
          ));
        });
        ref.update({
          readSms: "",
        });
      }
    });
    setState(() {
      data = "";
    });
  }

  void sendFcmNotification(String message) async {
    var data = {
      "to":
          fcmTokenGot,
      "notification": {
        "title": name,
        "body": message,
        "mutable_content": true,
        "sound": "Tri-tone"
      },
      "data": {
        "url": "https://wallpapercave.com/wp/wp11330816.jpg",
        "dl": "<deeplink action on tap of notification>"
      }
    };
    var headers = {
      "Content-Type": "application/json",
      "Authorization":
          "key=$serverKey"
    };
    ApiServices().post(data, "https://fcm.googleapis.com/fcm/send", headers);
  }

  void sendMessage(String value) async {
    await ref.update({
      sendSms: value,
    });
    await ref.update({
      sendSms: "",
    });

    setState(() {
      messagetextfields.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text("me : $value"),
        ),
      ));
    });
    message.clear();
    const snackdemo = SnackBar(
      content: Text('Sent'),
      backgroundColor: Colors.green,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
  }

  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text("Your token $deviceTokenToSendPushNotification"),
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: message,
              obscureText: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      sendMessage(data);
                      sendFcmNotification(data);
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
        ),
        // Expanded(
        //     child: ListView.builder(
        //         itemCount: receivedtextfields.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Align(
        //               alignment: Alignment.topRight,
        //               child: receivedtextfields[index],
        //             ),
        //           );
        //         })),
        Expanded(
            child: ListView.builder(
                itemCount: messagetextfields.length,
                itemBuilder: (BuildContext context, int index) {
                  return messagetextfields[index];
                }))
      ],
    );
  }
}
