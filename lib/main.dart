import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'result.dart';
import 'quiz.dart';
import 'help.dart';
import 'welcome.dart';
import 'music_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // فقط حالت عمودی (Portrait Up / Down)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Hive رو initialize و Box باز کن
  await Hive.initFlutter();
  await Hive.openBox("myBox");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 🎶 شروع موزیک وقتی اپ اجرا بشه
    Future.delayed(Duration.zero, () async {
      await MusicService().playMusic();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // ❌ وقتی اپ بسته شد یا ویجت نابود شد
    MusicService().stopMusic();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // ❌ وقتی اپ میره بک‌گراند
      MusicService().stopMusic();
    } else if (state == AppLifecycleState.resumed) {
      // 🎶 وقتی دوباره اپ برگشت فورگراند
      MusicService().playMusic();
    } else if (state == AppLifecycleState.detached) {
      // ❌ وقتی اپ Kill شد
      MusicService().stopMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomPage(),
      routes: {
        "/help": (context) => HelpPage(),
        "/home": (context) => WelcomPage(),
        "/quis": (context) => QuisPage(),
        "/result": (context) => ResultPage(),
      },
    );
  }
}
