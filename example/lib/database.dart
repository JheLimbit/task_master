import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

JsonEncoder encorder = new JsonEncoder.withIndent(' ');

/// Class of functions to help push to Firebase
class Database {
  /// Updates Firebase database at [children] with   "[location] : [data]"
  static Future<void> update(
      {required String children,
      required String location,
      dynamic data}) async {
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: 'DATABASE URL HERE')
        .ref()
        .child(children)
        .update({location: data});
  }

  /// Pushes [data] to Firebase at [children]
  static Future<void> push({required String children, dynamic data}) async {
    await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: 'DATABASE URL HERE')
        .ref()
        .child(children)
        .push()
        .set(data);
  }

  /// Gets data at location once
  static Future<dynamic> once(String children) async {
    DatabaseEvent val = await FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: 'DATABASE URL HERE')
        .ref()
        .child(children)
        .once();

    return val.snapshot.value;
  }

  /// Fires when data at [children] is updated
  static Stream<DatabaseEvent> onValue(String children) {
    return FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: 'DATABASE URL HERE')
        .ref(children)
        .onValue;
  }

  /// Gets the reference for the database at [child]
  static DatabaseReference reference(String child) {
    return FirebaseDatabase.instanceFor(
            app: Firebase.app(), databaseURL: 'DATABASE URL HERE')
        .ref()
        .child(child);
  }
}
