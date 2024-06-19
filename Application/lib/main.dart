import 'package:flutter/material.dart';
import 'package:hospitalapp/Screens/startscreen.dart';
import 'package:hospitalapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MedicaApp());
}

class MedicaApp extends StatefulWidget {
  const MedicaApp({super.key});

  @override
  State<MedicaApp> createState() => _AppState();
}

class _AppState extends State<MedicaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}
