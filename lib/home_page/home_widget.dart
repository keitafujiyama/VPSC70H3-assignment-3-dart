// PACKAGE
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global_file/global_class.dart';
import '../global_file/global_enumerator.dart';
import '../global_file/global_method.dart';
import '../global_file/global_provider.dart';
import 'home_class.dart';



// HOME WIDGET
class DayPanel extends StatefulWidget {

  // CONSTRUCTOR
  const DayPanel (this.day, this.isSleeping, {super.key});

  // PROPERTY
  final bool isSleeping;
  final DayClass day;



  // MAIN
  @override
  State <DayPanel> createState () => _DayPanelState ();
}
class _DayPanelState extends State <DayPanel> {

  // PROPERTY
  bool isOpened = true;



  // MAIN
  @override
  void initState () {
    super.initState ();

    final date = DateTime.now ();

    if (date.year != widget.day.date.year || date.month != widget.day.date.month || date.day != widget.day.date.day) {
      setState (() => isOpened = false);
    }
  }

  @override
  Widget build (_) {
    final size = MediaQuery.of (_).size;
    return Padding (
      padding: EdgeInsets.symmetric (vertical: size.shortestSide * 0.05),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector (
            onTap: () => setState (() => isOpened = !isOpened),
            child: ListTile (
              contentPadding: EdgeInsets.zero,
              title: Text (DateFormat.MMMMd ().format (widget.day.date),
                textScaleFactor: 1,
                style: TextStyle (
                  color: Theme.of (_).textTheme.bodyText1!.color,
                  fontSize: gSetSize (context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon (isOpened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Theme.of (_).textTheme.bodyText1!.color,
                size: gSetSize (context),
              ),
            ),
          ),
          if (isOpened) Column (
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final events in widget.day.lists) Stack (
                alignment: Alignment.center,
                children: [
                  Container (
                    height: size.shortestSide * 0.01,
                    width: double.maxFinite,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular (5),
                      gradient: LinearGradient (colors: widget.isSleeping ? [Colors.blue.shade900, Colors.lightBlue] : [Colors.red.shade900, Colors.orange]),
                    ),
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: events.map ((GEventClass event) {
                      switch (event.type) {
                        case GEventEnumerator.continuing:
                          return const SizedBox.shrink ();

                        case GEventEnumerator.now:
                          return _EventIcon (event, Icons.bed);

                        case GEventEnumerator.sleeping:
                          return _EventIcon (event, Icons.mode_night);

                        case GEventEnumerator.other:
                          return const SizedBox.shrink ();

                        case GEventEnumerator.waking:
                          return _EventIcon (event, Icons.sunny);
                      }
                    }).toList (),
                  ),
                ],
              ),
              const ListTile (dense: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {

  // CONSTRUCTOR
  const _EventIcon (this.event, this.icon);

  // PROPERTY
  final GEventClass event;
  final IconData icon;



  // MAIN
  @override
  Widget build (BuildContext context) {
    final size = MediaQuery.of (context).size;
    return Consumer <GServerProvider> (builder: (_, GServerProvider provider, __) => GestureDetector (
      onTap: () {
        if (event.index >= 0 && event.index <= provider.calculateLength ()) {
          final dates = <DateTime> [if (event.type == GEventEnumerator.sleeping) event.date else provider.events [event.index - 1].date, if (event.type == GEventEnumerator.waking) event.date else provider.events [event.index + 1].date];
          final minute = dates.last.difference (dates.first).inMinutes;
          showBottomSheet <void> (
            backgroundColor: provider.isSleeping ? Colors.grey.shade900 : Colors.grey.shade50,
            context: context,
            shape: const RoundedRectangleBorder (borderRadius: BorderRadius.vertical (top: Radius.circular (5))),
            builder: (_) => GestureDetector (
              onTap: () => Navigator.of (_).pop,
              child: Table (
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth (0.4),
                  1: FlexColumnWidth (0.2),
                  2: FlexColumnWidth (0.4),
                },
                children: <List <String>> [['Bed Time', DateFormat.MMMd ().add_Hm ().format (dates.first)], ['Wake-up Time', DateFormat.MMMd ().add_Hm ().format (dates.last)], ['Sleep Hours', DateFormat.Hm ().format (DateTime (event.date.year, event.date.month, event.date.day, minute ~/ 60, minute % 60))]].map ((List <String> strings) => TableRow (children: [
                  Text (strings.first,
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.75,
                    style: TextStyle (
                      color: Theme.of (_).textTheme.bodyText1!.color,
                      fontSize: gSetSize (context),
                    ),
                  ),
                  Text (':',
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.75,
                    style: TextStyle (
                      color: Theme.of (_).textTheme.bodyText1!.color,
                      fontSize: gSetSize (context),
                    ),
                  ),
                  Text (strings.last,
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.75,
                    style: TextStyle (
                      color: Theme.of (_).textTheme.bodyText1!.color,
                      fontSize: gSetSize (context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ].map ((Widget widget) => Padding (
                  padding: EdgeInsets.symmetric (vertical: size.shortestSide * 0.025),
                  child: widget,
                ),).toList (),),).toList (),
              ),
            ),
          );
        }
      },
      child: Container (
        margin: EdgeInsets.symmetric (vertical: size.shortestSide * 0.025),
        padding: EdgeInsets.all (size.shortestSide * 0.01),
        decoration: BoxDecoration (
          color: Theme.of (_).textTheme.bodyText1!.color,
          shape: BoxShape.circle,
        ),
        child: Icon (icon,
          color: Theme.of (_).scaffoldBackgroundColor,
          size: size.shortestSide * 0.03,
        ),
      ),
    ),);
  }
}

class SleepingCircle extends StatelessWidget {

  // CONSTRUCTOR
  const SleepingCircle (this.icon, {super.key});

  // PROPERTY
  final IconData icon;



  // MAIN
  @override
  Widget build (BuildContext context) {
    final size = MediaQuery.of (context).size;
    return Container (
      padding: EdgeInsets.all (size.shortestSide * 0.01),
      decoration: BoxDecoration (
        color: Theme.of (context).textTheme.bodyText1!.color,
        shape: BoxShape.circle,
      ),
      child: Icon (icon,
        color: Theme.of (context).scaffoldBackgroundColor,
        size: size.shortestSide * 0.04,
      ),
    );
  }
}
