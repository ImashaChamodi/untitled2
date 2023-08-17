import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:untitled2/screen/first.dart';
import 'package:untitled2/screen/hotel_login.dart';
import 'package:untitled2/screen/hotel_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(HotelApp());
}

class HotelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),

        '/hotel_login':(context) => HotelLoginPage(),
      },
    );
  }
}
