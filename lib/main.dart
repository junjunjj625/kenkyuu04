import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kenkyuu04/screens/map_screen.dart';
import 'package:kenkyuu04/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapScreen(),
        //home: const MainScreen(),
    );
  }
}
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> datas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Text(datas.toString()),
            StreamBuilder<QuerySnapshot>(
              stream: getStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Text('empty');
                }
                final datas = snapshot.data!.docs.map((doc) => doc.data());

                return Text(datas.toString());
              },
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('push'),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getStream() {
    final db = FirebaseFirestore.instance;
    final collectionRef = db.collection('App_Data');
    // コレクションのストリームを返す
    return collectionRef.snapshots();
  }

  Future<void> onPressed() async {
    final db = FirebaseFirestore.instance;
    final collectionRef = db.collection('App_Data');
    final collection = await collectionRef.get();
    final docs = collection.docs;
    if (docs.isNotEmpty) {
      setState(() {
        for (var doc in docs) {
          datas.add(doc.data());
        }
      });
    }
  }
}
