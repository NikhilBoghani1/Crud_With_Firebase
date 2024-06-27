import 'package:crud_app/view/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCEKvgqd05i8egke6-pmyBawWBAZs4IxzE",
      appId: "1:226898024670:android:9ef6227fe6fb0c3365ca4f",
      messagingSenderId: "226898024670",
      projectId: "crud-firebase-998af",
      storageBucket: "crud-firebase-998af.appspot.com",
    ),
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomeView(),
    );
  }
}
