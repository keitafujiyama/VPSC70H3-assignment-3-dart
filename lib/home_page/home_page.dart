// PACKAGE
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../global_file/global_class.dart';
import '../global_file/global_enumerator.dart';
import '../global_file/global_method.dart';
import '../global_file/global_provider.dart';
import 'home_class.dart';
import 'home_widget.dart';



// HOME PAGE
class HomePage extends StatelessWidget {

  // CONSTRUCTOR
  const HomePage ({super.key});

  // METHOD
  DayClass _createDay (List <GEventClass> events) {
    final lists = <List <GEventClass>> [];

    for (var i = 0; i < events.length; i = i + 9) {
      lists.add (events.sublist (i, i + (events.length - i >= 9 ? 9 : events.length % 9)));
    }

    for (var i = 0; i < lists.length; i ++) {
      if ((GEventEnumerator.now == lists [i].first.type || GEventEnumerator.waking == lists [i].first.type) || i > 0) {
        lists [i].insert (0, GEventClass.local (lists [i].first.date, GEventEnumerator.continuing));
      }

      if (GEventEnumerator.sleeping == lists [i].last.type || i < lists.length - 1) {
        lists [i].add (GEventClass.local (lists [i].last.date, GEventEnumerator.continuing));
      }
    }

    return DayClass (lists.first.first.date, lists);
  }

  List <DayClass> _createList (List <GEventClass> events) {
    final list1 = <GEventClass> [];
    final list2 = <DayClass> [];

    list1.addAll (events);

    if (list1.isNotEmpty && GEventEnumerator.sleeping == list1.last.type) {
      list1.add (GEventClass.local (DateTime.now (), GEventEnumerator.now));
    }

    final list3 = <GEventClass> [];
    for (var i = 0; i < list1.length; i ++) {
      if (i > 0) {
        if (list1 [i].date.year > list1 [i - 1].date.year || list1 [i].date.month > list1 [i - 1].date.month || list1 [i].date.day > list1 [i - 1].date.day) {
          if (GEventEnumerator.waking == list3.first.type) {
            list3.insert (0, GEventClass.local (list3.first.date, GEventEnumerator.continuing));
          }

          if (GEventEnumerator.sleeping == list3.last.type) {
            list3.add (GEventClass.local (list3.last.date, GEventEnumerator.continuing));
          }

          list2.insert (0, _createDay (list3));
          list3.clear ();
        }

        list3.add (list1 [i]);
      } else {
        list3.add (list1 [i]);
      }
    }

    list2.insert (0, _createDay (list3));

    return list2;
  }



  // MAIN
  @override
  Widget build (BuildContext context) {
    final size = MediaQuery.of (context).size;
    return Consumer <GServerProvider> (builder: (_, GServerProvider provider, __) {
      final date = DateTime.fromMicrosecondsSinceEpoch (0);

      for (var i = 0; i < provider.calculateLength (); i = i + 2) {
        date.add (provider.events [i + 1].date.difference (provider.events [i].date));
      }

      final minute = date.difference (DateTime.fromMicrosecondsSinceEpoch (0)).inMinutes;

      return Scaffold (
        appBar: AppBar (
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector (
              onTap: () => provider.publishEvent (),
              child: Icon (Icons.more_time, size: gSetSize (context)),
            ),
            GestureDetector (
              onTap: () => showDialog <void> (
                context: context,
                builder: (_) => AlertDialog (
                  backgroundColor: provider.isSleeping ? Colors.grey.shade900 : Colors.grey.shade50,
                  contentPadding: EdgeInsets.all (size.shortestSide * 0.05),
                  shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular (5)),
                  content: Column (
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text ('Zzz...',
                        textScaleFactor: 1,
                        style: TextStyle (
                          color: Theme.of (_).textTheme.bodyText1!.color,
                          fontSize: gSetSize (context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const ListTile (dense: true),
                      Text ('This application is an application to record sleep times by accessing with a parameter or tapping the Add button of this application.',
                        textScaleFactor: 0.75,
                        style: TextStyle (
                          color: Theme.of (_).textTheme.bodyText1!.color,
                          fontSize: gSetSize (context),
                        ),
                      ),
                      const ListTile (dense: true),
                      Text.rich (TextSpan (children: [
                        TextSpan (text: '©KEITA FUJIYAMA ${DateTime.now ().year} | '),
                        TextSpan (
                          text: 'LICENSE',
                          recognizer: TapGestureRecognizer ()..onTap = () => showLicensePage (
                            applicationName: 'Assignment 3',
                            applicationLegalese: 'Keita Fujiyama',
                            context: context,
                          ),
                        ),
                        const TextSpan (text: ' | '),
                        TextSpan (
                          recognizer: TapGestureRecognizer ()..onTap = () => launchUrlString ('https://github.com/keitafujiyama/VPSC70H3-assignment-3/'),
                          text: 'REPOSITORY',
                        ),
                      ],),
                        textScaleFactor: 0.75,
                        style: TextStyle (
                          color: Colors.grey,
                          fontSize: gSetSize (context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              child: Icon (Icons.info_outline, size: gSetSize (context)),
            ),
          ].map ((Widget widget) => Padding (
            padding: EdgeInsets.only (right: size.shortestSide * 0.05),
            child: widget,
          ),).toList (),
        ),
        body: SingleChildScrollView (
          padding: EdgeInsets.symmetric (horizontal: size.shortestSide * 0.05),
          child: provider.events.isNotEmpty ? Column (
            mainAxisSize: MainAxisSize.min,
            children: [
              if (GEventEnumerator.sleeping == provider.events.last.type) Stack (
                alignment: Alignment.center,
                children: [
                  Padding (
                    padding: EdgeInsets.symmetric (horizontal: size.shortestSide * 0.005),
                    child: ShaderMask (
                      shaderCallback: (Rect rect) => LinearGradient (colors: [Colors.blue.shade900, Colors.lightBlue]).createShader (rect),
                      child: LinearProgressIndicator (
                        backgroundColor: Colors.grey.withOpacity(0.25),
                        minHeight: size.shortestSide * 0.01,
                        valueColor: const AlwaysStoppedAnimation (Colors.white),
                      ),
                    ),
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SleepingCircle (Icons.mode_night),
                      Container (
                        padding: EdgeInsets.all (size.shortestSide * 0.05),
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular (5),
                          color: Theme.of (_).scaffoldBackgroundColor.withOpacity (0.5),
                        ),
                        child: Text ('${DateTime.now ().difference (provider.events.last.date).inHours} hours in bed...\nfrom ${DateFormat.MMMd ().add_Hm ().format (provider.events.last.date)}',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                          style: TextStyle (
                            color: Theme.of (_).textTheme.bodyText1!.color,
                            fontSize: gSetSize (context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SleepingCircle (Icons.bed),
                    ],
                  ),
                ],
              ),
              if (provider.events.length > 1) Column (
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text ((minute ~/ provider.calculateLength ()).toString (),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 7.5,
                    style: TextStyle (
                      color: Theme.of (_).textTheme.bodyText1!.color,
                      fontSize: gSetSize (context),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text ('hours',
                    textScaleFactor: 2.5,
                    style: TextStyle (
                      color: Theme.of (_).textTheme.bodyText1!.color,
                      fontSize: gSetSize (context),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox (
                    width: size.width * 0.5,
                    child: Column (
                      mainAxisSize: MainAxisSize.min,
                      children: [const Divider (color: Colors.grey),
                        Column (
                          mainAxisSize: MainAxisSize.min,
                          children: <List <String>> [['total time', '${provider.events.length ~/ 2} times'], ['total hour', '${minute ~/ 60} hours']].map ((List <String> strings) => Row (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: strings.map ((String string) => Text (string,
                              textScaleFactor: 0.75,
                              style: TextStyle (
                                color: Colors.grey,
                                fontSize: gSetSize (context),
                              ),
                            ),).toList (),
                          ),).toList (),
                        ),
                      ],
                    ),
                  ),
                  const ListTile (dense: true),
                ],
              ),
              for (final day in _createList (provider.events)) DayPanel (day, provider.isSleeping),
            ],
          ) : Column (
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile (dense: true),
              ListTile (
                contentPadding: EdgeInsets.all (size.shortestSide * 0.005),
                title: Text ('No History',
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.75,
                  style: TextStyle (
                    color: Colors.grey,
                    fontSize: gSetSize (context),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: provider.isConnected ? ListTile (
          tileColor: provider.isSleeping ? Colors.grey.shade900 : Colors.grey.shade50,
          title: GestureDetector (
            onTap: () => Clipboard.setData (ClipboardData (text: 'https://keitafujiyama.github.io/VPSC70H3-assignment-3?id=${provider.id}')).then ((_) => ScaffoldMessenger.of (context).showSnackBar (SnackBar (
              backgroundColor: Colors.transparent,
              elevation: double.minPositive,
              content: Text ('URL Copied',
                textAlign: TextAlign.center,
                textScaleFactor: 0.75,
                style: TextStyle (
                  color: Theme.of (context).primaryColor,
                  fontSize: gSetSize (context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),),),
            child: Text ("'${provider.id}'",
              textAlign: TextAlign.center,
              textScaleFactor: 0.75,
              style: TextStyle (
                color: Theme.of (_).primaryColor,
                decoration: TextDecoration.underline,
                fontSize: gSetSize (context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ) : const SizedBox.shrink (),
      );
    },);
  }
}
