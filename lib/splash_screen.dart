import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void goToWebViewScreen(BuildContext ctx) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(ctx).pushReplacementNamed('/home');
    });
  }

  @override
  void initState() {
    super.initState();
    goToWebViewScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0.0, 0.0),
        child: Container(),
      ),
      body: Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(255, 247,247,247),
        child: Image.asset(
          "assets/icons/splash.jpg",
          height: size.height,
          width: size.width,
        ),
      ),
    );
  }
}
