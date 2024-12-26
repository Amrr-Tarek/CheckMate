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
    apiKey: 'AIzaSyCYP1cmzuPJLGvo0DDp_3vrOTWSC7XhXqU',
    appId: '1:32005702382:web:f2b0ed0e72575385eba9ff',
    messagingSenderId: '32005702382',
    projectId: 'check-mate-0',
    authDomain: 'check-mate-0.firebaseapp.com',
    storageBucket: 'check-mate-0.firebasestorage.app',
    measurementId: 'G-QYPT9WHPKR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqozcJUMxi4KTYhyAYsB3z2rSaYHY_jKE',
    appId: '1:32005702382:android:305ae4326a8931b1eba9ff',
    messagingSenderId: '32005702382',
    projectId: 'check-mate-0',
    storageBucket: 'check-mate-0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC70mjz9FuxXDuG1DYaNBSbODQBDFnzoHI',
    appId: '1:32005702382:ios:11248d07c32b38f2eba9ff',
    messagingSenderId: '32005702382',
    projectId: 'check-mate-0',
    storageBucket: 'check-mate-0.firebasestorage.app',
    iosClientId: '32005702382-leu5en06t436aateska6s4lif9424pgs.apps.googleusercontent.com',
    iosBundleId: 'com.example.checkmate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC70mjz9FuxXDuG1DYaNBSbODQBDFnzoHI',
    appId: '1:32005702382:ios:11248d07c32b38f2eba9ff',
    messagingSenderId: '32005702382',
    projectId: 'check-mate-0',
    storageBucket: 'check-mate-0.firebasestorage.app',
    iosClientId: '32005702382-leu5en06t436aateska6s4lif9424pgs.apps.googleusercontent.com',
    iosBundleId: 'com.example.checkmate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYP1cmzuPJLGvo0DDp_3vrOTWSC7XhXqU',
    appId: '1:32005702382:web:4fe514ddcf5f4239eba9ff',
    messagingSenderId: '32005702382',
    projectId: 'check-mate-0',
    authDomain: 'check-mate-0.firebaseapp.com',
    storageBucket: 'check-mate-0.firebasestorage.app',
    measurementId: 'G-GJB8VRMTMM',
  );

}