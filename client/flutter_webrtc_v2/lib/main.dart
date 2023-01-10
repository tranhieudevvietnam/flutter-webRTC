import 'package:flutter/material.dart';
import 'package:flutter_webrtc_v2/pages/home_screen.dart';
import 'package:flutter_webrtc_v2/utils/share_preference_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharePreferenceUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
