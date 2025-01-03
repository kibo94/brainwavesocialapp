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
    apiKey: 'AIzaSyC3wagsIc_wE3hXjBfbEkMwejkyMwwOS_I',
    appId: '1:1080333670709:web:758284b58326bcf98e147c',
    messagingSenderId: '1080333670709',
    projectId: 'brainwave-social-media-c73b0',
    authDomain: 'brainwave-social-media-c73b0.firebaseapp.com',
    storageBucket: 'brainwave-social-media-c73b0.appspot.com',
    measurementId: 'G-JPDZJSQ0G7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuvcH16s30kRSasBcJFiLgZnvDi9R-oMM',
    appId: '1:1080333670709:android:8d8fd036b2d506418e147c',
    messagingSenderId: '1080333670709',
    projectId: 'brainwave-social-media-c73b0',
    storageBucket: 'brainwave-social-media-c73b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBB9mBj4jQrahwGNdPJYzxpzm32AP2kIxE',
    appId: '1:1080333670709:ios:0bfc13a8ef24bd138e147c',
    messagingSenderId: '1080333670709',
    projectId: 'brainwave-social-media-c73b0',
    storageBucket: 'brainwave-social-media-c73b0.appspot.com',
    androidClientId: '1080333670709-d1e2q1cd2gamo3qelb07o3ruqhb3ihee.apps.googleusercontent.com',
    iosClientId: '1080333670709-gmn6vviiamuav7mrelrsb9van20c6io5.apps.googleusercontent.com',
    iosBundleId: 'app.brainwave.brainwavesocialapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBB9mBj4jQrahwGNdPJYzxpzm32AP2kIxE',
    appId: '1:1080333670709:ios:0bfc13a8ef24bd138e147c',
    messagingSenderId: '1080333670709',
    projectId: 'brainwave-social-media-c73b0',
    storageBucket: 'brainwave-social-media-c73b0.appspot.com',
    androidClientId: '1080333670709-d1e2q1cd2gamo3qelb07o3ruqhb3ihee.apps.googleusercontent.com',
    iosClientId: '1080333670709-gmn6vviiamuav7mrelrsb9van20c6io5.apps.googleusercontent.com',
    iosBundleId: 'app.brainwave.brainwavesocialapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3wagsIc_wE3hXjBfbEkMwejkyMwwOS_I',
    appId: '1:1080333670709:web:132185a6b8bea68c8e147c',
    messagingSenderId: '1080333670709',
    projectId: 'brainwave-social-media-c73b0',
    authDomain: 'brainwave-social-media-c73b0.firebaseapp.com',
    storageBucket: 'brainwave-social-media-c73b0.appspot.com',
    measurementId: 'G-8PYFWH5G8V',
  );

}