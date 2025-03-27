import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Fuchsia - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpWyI7kqSu0p7mkX-hh0vKzZMyLv-PqwU',
    appId: '1:618393088860:web:33774d3110de479c6a4799',
    messagingSenderId: '618393088860',
    projectId: 'habister-5885a',
    authDomain: 'habister-5885a.firebaseapp.com',
    storageBucket: 'habister-5885a.appspot.com',
    measurementId: 'G-V44PTNQVDJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmroiZaurSojKzdIj79pzEGeM46UzIPRQ',
    appId: '1:618393088860:android:765614a5c8cd3fe46a4799',
    messagingSenderId: '618393088860',
    projectId: 'habister-5885a',
    storageBucket: 'habister-5885a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkHwDX0xngHQfRvVCAtQxT7ZmQieq1egw',
    appId: '1:618393088860:ios:4844f88bc20341fc6a4799',
    messagingSenderId: '618393088860',
    projectId: 'habister-5885a',
    storageBucket: 'habister-5885a.appspot.com',
    iosBundleId: 'com.example.habitFlutterApp.extension',
  );
}
