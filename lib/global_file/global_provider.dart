// PACKAGE
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_class.dart';
import 'global_enumerator.dart';



// GLOBAL PROVIDER
class GServerProvider extends ChangeNotifier {

  // METHOD
  int calculateLength () {
    var length = events.length;

    if (length.isOdd) {
      length --;
    }

    return length;
  }

  void _addEvent (GEventClass event) {
    if (event.id == id) {
      if (events.isNotEmpty) {
        if (event.date.isAfter (events.last.date) && (event.type == GEventEnumerator.sleeping && events.last.type == GEventEnumerator.waking) || (event.type == GEventEnumerator.waking && events.last.type == GEventEnumerator.sleeping)) {
          events.add (event);
        }
      } else {
        if (event.type == GEventEnumerator.sleeping) {
          events.add (event);
        }
      }

      notifyListeners ();
    }
  }

  void connectServer () => SharedPreferences.getInstance ().then ((SharedPreferences preference) async {
    final url = Uri.base.queryParameters;

    final fromUrl = url [_key] ?? '';
    final fromStorage = preference.getString (_key) ?? '';

    if (fromUrl.isNotEmpty) {
      id = fromUrl;
    } else if (fromStorage.isNotEmpty) {
      id = fromStorage;
    } else {
      var number = Random ().nextInt (1000000000).toString ();

      while (number.length < 9) {
        number = '0$number';
      }

      id = 'user$number';
    }

    preference.setString (_key, id);


    _server = PubNub (defaultKeyset: Keyset (
      publishKey: 'pub-c-bad4c475-8b21-4034-ba20-a293d52b74cd',
      subscribeKey: 'sub-c-fdd27250-365d-43f6-8037-e4d1d22be4e5',
      userId: UserId (id),
    ),);

    final history = _server.channel (_channel).history ();

    for (var i = 0; i < 5; i ++) {
      await history.more ();
    }

    for (final message in history.messages) {
      _addEvent (GEventClass.fromMap (events.length, message.content as Map <String, dynamic>));
    }

    _setMode ();

    _server.subscribe (channels: {_channel}).messages.listen ((Envelope envelope) {
      if (_channel == envelope.channel) {
        _addEvent (GEventClass.fromMap (events.length, envelope.content as Map <String, dynamic>));
        _setMode ();
      }
    });


    isConnected = true;


    if ((url ['publishing'] ?? '') == 'yes') {
      publishEvent ();
    }

    notifyListeners ();
  });

  void publishEvent () {
    var type = GEventEnumerator.other;

    if (isConnected) {
      if (events.isNotEmpty) {
        if (events.last.type == GEventEnumerator.sleeping) {
          type = GEventEnumerator.waking;
        }

        if (events.last.type == GEventEnumerator.waking) {
          type = GEventEnumerator.sleeping;
        }
      } else {
        type = GEventEnumerator.sleeping;
      }

      if (GEventEnumerator.sleeping == type || GEventEnumerator.waking == type) {
        _server.publish (_channel, <String, dynamic> {
          'date': DateTime.now ().millisecondsSinceEpoch,
          'id': id,
          'type': type.name,
        });
      }
    }
  }

  void _setMode () {
    if (events.isNotEmpty) {
      if (events.last.type == GEventEnumerator.sleeping) {
        isSleeping = true;
        notifyListeners ();
      }

      if (events.last.type == GEventEnumerator.waking) {
        isSleeping = false;
        notifyListeners ();
      }
    }
  }

  // PROPERTY
  bool isConnected = false;
  bool isSleeping = false;
  final List <GEventClass> events = [];
  final String _channel = 'SLEEP';
  final String _key = 'id';
  PubNub _server = PubNub ();
  String id = '';
}
