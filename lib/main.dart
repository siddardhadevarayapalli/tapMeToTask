import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TapMe'),
    );
  }
}

List<Widget> receivedtextfields = [];
List<Widget> sendtextfields = [];
List<Widget> messagetextfields = [];

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    readData();
    super.initState();
  }

  TextEditingController message = TextEditingController();

  readData() async {
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot.value}'); // DataSnapshot
      if (event.snapshot.child("readmessage").value != "") {
        setState(() {
          messagetextfields.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child:
                  Text("Their :${event.snapshot.child("readmessage").value}"),
            ),
          ));
        });
        ref.update({
          "readmessage": "",
        });
      }
    });
    setState(() {
      data = "";
    });
  }

  void sendData(String value) async {
    await ref.update({
      "sendmessage": value,
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

  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  messagetextfields.clear();
                });
              },
              icon: Icon(Icons.clear))
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                        sendData(data);
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
      ),
    );
  }
}
