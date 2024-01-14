import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashSreen extends StatefulWidget {
  const SplashSreen({super.key});

  @override
  State<SplashSreen> createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), (() {
      Navigator.pushReplacementNamed(context, '/');
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: 300,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/image/logo.png'),
          const SizedBox(height: 30),
          const Text(
            'Shoes Store',
            style: TextStyle(fontSize: 40),
          )
        ]),
      )),
    );
  }
}
