import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Views/fill_out_survey.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCNcGQijY1Oqef66FNIkpqs_I1npRGPlqw",
            authDomain: "lifestyle-survey-a5181.firebaseapp.com",
            projectId: "lifestyle-survey-a5181",
            storageBucket: "lifestyle-survey-a5181.appspot.com",
            messagingSenderId: "855163766086",
            appId: "1:855163766086:web:9f3658acbee265c7031147"));
  } else {
    Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SurveyPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
