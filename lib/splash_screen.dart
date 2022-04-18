import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    goToWebViewScreen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0.0, 0.0),
        child: Container(),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Image.asset(
          "assets/icons/app_logo.png",
          height: 200,
          width: 200,
        ),
      ),
    );
  }

  void goToWebViewScreen(BuildContext ctx) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(ctx).pushReplacementNamed('/home');
    });
  }
}
