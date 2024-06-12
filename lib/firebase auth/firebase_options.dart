// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDYmQVoOaBneAu7lLhLAdb2zZa9R6pixzI',
    appId: '1:74591403274:web:976d3e0a886e6019240ef3',
    messagingSenderId: '74591403274',
    projectId: 'paybill-33f3d',
    authDomain: 'paybill-33f3d.firebaseapp.com',
    storageBucket: 'paybill-33f3d.appspot.com',
    measurementId: 'G-WRPR1JNFX8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZ3DlzQYTrv5bpMWxVeUhb6OfNSyH-Vgg',
    appId: '1:74591403274:android:785de4941e97d088240ef3',
    messagingSenderId: '74591403274',
    projectId: 'paybill-33f3d',
    storageBucket: 'paybill-33f3d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCX4SLeXNtQK1PRBrnD79ugQoG6hQxcBy8',
    appId: '1:74591403274:ios:6063a733181fa136240ef3',
    messagingSenderId: '74591403274',
    projectId: 'paybill-33f3d',
    storageBucket: 'paybill-33f3d.appspot.com',
    iosBundleId: 'com.example.paybill',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCX4SLeXNtQK1PRBrnD79ugQoG6hQxcBy8',
    appId: '1:74591403274:ios:6063a733181fa136240ef3',
    messagingSenderId: '74591403274',
    projectId: 'paybill-33f3d',
    storageBucket: 'paybill-33f3d.appspot.com',
    iosBundleId: 'com.example.paybill',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDYmQVoOaBneAu7lLhLAdb2zZa9R6pixzI',
    appId: '1:74591403274:web:dce73b4c75ce74e2240ef3',
    messagingSenderId: '74591403274',
    projectId: 'paybill-33f3d',
    authDomain: 'paybill-33f3d.firebaseapp.com',
    storageBucket: 'paybill-33f3d.appspot.com',
    measurementId: 'G-3VSSE49GCS',
  );
}
