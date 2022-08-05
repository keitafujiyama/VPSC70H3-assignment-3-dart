// PACKAGE
import 'package:flutter/material.dart';

import 'global_file/global_method.dart';



// SPLASH PAGE
class SplashPage1 extends StatefulWidget {

  // CONSTRUCTOR
  const SplashPage1 ({super.key});



  // MAIN
  @override
  State <SplashPage1> createState () => _SplashPage1State ();
}
class _SplashPage1State extends State <SplashPage1> {

  @override
  void initState () {
    super.initState ();

    Future <void>.delayed (const Duration (seconds: 1), () => Navigator.of (context).pushReplacementNamed ('/splash'));
  }

  @override
  Widget build (_) => Scaffold (
    backgroundColor: const Color (0xFF002554),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    body: Center (child: Text ('Assignment 3',
      textScaleFactor: 1.5,
      style: TextStyle (
        color: Colors.white,
        fontSize: gSetSize (context),
        fontWeight: FontWeight.bold,
      ),
    ),),
    floatingActionButton: Text ('Keita Fujiyama\nVPSC70H3',
      textAlign: TextAlign.center,
      textScaleFactor: 1,
      style: TextStyle (
        color: Colors.white,
        fontSize: gSetSize (context),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class SplashPage2 extends StatefulWidget {

  // CONSTRUCTOR
  const SplashPage2 ({super.key});



  // MAIN
  @override
  State <SplashPage2> createState () => _SplashPage2State ();
}
class _SplashPage2State extends State <SplashPage2> {

  @override
  void initState () {
    super.initState ();

    Future <void>.delayed (const Duration (seconds: 1), () => Navigator.of (context).pushReplacementNamed ('/home'));
  }

  @override
  Widget build (_) => Scaffold (body: Center (child: Text ('Zzz...',
    textScaleFactor: 1.5,
    style: TextStyle (
      color: Theme.of (_).primaryColor,
      fontSize: gSetSize (context),
      fontWeight: FontWeight.bold,
    ),
  ),),);
}
