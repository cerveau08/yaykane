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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDVozbFU4vYVwYU7kzlpT4eH8vBcIBJUKs',
    appId: '1:531726764214:web:56a74a95f8b509699e7e17',
    messagingSenderId: '531726764214',
    projectId: 'yaykane-e7188',
    authDomain: 'yaykane-e7188.firebaseapp.com',
    storageBucket: 'yaykane-e7188.firebasestorage.app',
    measurementId: 'G-B4HSTDH8TP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpJ1AOXECNBmoPfKlsguS_AHAHG7IGnoc',
    appId: '1:531726764214:android:7f01dd5c831e21db9e7e17',
    messagingSenderId: '531726764214',
    projectId: 'yaykane-e7188',
    storageBucket: 'yaykane-e7188.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9yCXmTnPfcWdQKUUF22x5F5aD0Sx8Mvk',
    appId: '1:531726764214:ios:78d8a57b78f7a4c69e7e17',
    messagingSenderId: '531726764214',
    projectId: 'yaykane-e7188',
    storageBucket: 'yaykane-e7188.firebasestorage.app',
    iosBundleId: 'com.example.yaykane',
  );
}