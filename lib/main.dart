// PACKAGE
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'global_file/global_provider.dart';
import 'home_page/home_page.dart';
import 'splash_page.dart';




// MAIN
void main () {
  setUrlStrategy (PathUrlStrategy ());

  runApp (const MyApp ());
}

class MyApp extends StatelessWidget {

  // CONSTRUCTOR
  const MyApp ({super.key});



  // MAIN
  @override
  Widget build (BuildContext context) {
    rootBundle.loadString ('asset/openFontLicense.txt').then ((String txt) => LicenseRegistry.addLicense (() => Stream <LicenseEntry>.fromIterable (<LicenseEntry> [LicenseEntryWithLineBreaks (<String> ['google_fonts'], txt)])));
    return ChangeNotifierProvider <GServerProvider> (
      create: (_) => GServerProvider ()..connectServer (),
      child: Consumer <GServerProvider> (builder: (_, GServerProvider provider, __) => WillPopScope (
        onWillPop: () async => false,
        child: MaterialApp (
          initialRoute: '/',
          themeMode: provider.isSleeping ? ThemeMode.dark : ThemeMode.light,
          title: 'Zzz...(¦3ꇤ[#]',
          darkTheme: ThemeData (
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.nunito ().fontFamily,
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.black,
            textTheme: const TextTheme (bodyText1: TextStyle (color: Colors.white)),
            appBarTheme: AppBarTheme (
              actionsIconTheme: const IconThemeData (color: Colors.blue),
              backgroundColor: Colors.black,
              centerTitle: true,
              elevation: double.minPositive,
              iconTheme: const IconThemeData (color: Colors.blue),
              titleTextStyle: TextStyle (
                color: Colors.blue,
                fontFamily: GoogleFonts.nunito ().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onGenerateRoute: (RouteSettings setting) {
            switch (setting.name) {
              case '/home':
                return PageRouteBuilder <void> (pageBuilder: (_, __, ___) => const HomePage ());

              case '/splash':
                return PageRouteBuilder <void> (pageBuilder: (_, __, ___) => const SplashPage2 ());

              default:
                return PageRouteBuilder <void> (pageBuilder: (_, __, ___) => const SplashPage1 ());
            }
          },
          theme: ThemeData (
            brightness: Brightness.light,
            fontFamily: GoogleFonts.nunito ().fontFamily,
            primaryColor: Colors.red,
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme (bodyText1: TextStyle (color: Colors.black)),
            appBarTheme: AppBarTheme (
              actionsIconTheme: const IconThemeData (color: Colors.red),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: double.minPositive,
              iconTheme: const IconThemeData (color: Colors.red),
              titleTextStyle: TextStyle (
                color: Colors.red,
                fontFamily: GoogleFonts.nunito ().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),),
    );
  }
}
