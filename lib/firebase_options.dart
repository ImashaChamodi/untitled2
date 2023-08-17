// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeLZwL8DDIwT1-PVmc1PR2JPLAcu8kMnY',
    appId: '1:643981433750:android:3b6b6cbba4b3f85d795bb7',
    messagingSenderId: '643981433750',
    projectId: 'tourguide-3e3ac',
    databaseURL: 'https://tourguide-3e3ac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tourguide-3e3ac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDI7E-8QlLvwKwk0pvIq-Pho0FirDsRQfw',
    appId: '1:643981433750:ios:96b0dc1fd1616f76795bb7',
    messagingSenderId: '643981433750',
    projectId: 'tourguide-3e3ac',
    databaseURL: 'https://tourguide-3e3ac-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gs://tourguide-3e3ac.appspot.com',
    iosClientId: '643981433750-ja6kehjkoveq3kuquk59n2tu9lnoe1uj.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled2',
  );
}