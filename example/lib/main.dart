import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'board_viewer.dart';
import 'project_viewer.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'database.dart';

import 'package:css/css.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CSS.darkTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? managemntData;
  String selectedProject = '';
  String currentUID = '123';
  var loading = false;

  dynamic users;
  dynamic labels;
  dynamic completeData;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    firebaseReset();
    await Database.once('Users').then((val) {
      users = val;
      setState(() {});
    });

    await Database.once('Label').then((val) {
      labels = val;
      setState(() {});
    });

    await Database.once('complete').then((val) {
      completeData = val;
      setState(() {});
    });

    firebaseListener();
  }

  // Stream listener variables to hold listening streams
  StreamSubscription<DatabaseEvent>? completeAdded;
  StreamSubscription<DatabaseEvent>? userUpdated;
  StreamSubscription<DatabaseEvent>? labelUpdated;

  // Listens for changes in the database and updates the data in the application accordingly
  void firebaseListener() {
    completeAdded = Database.onValue('complete').listen((event) {
      setState(() {
        completeData = event.snapshot.value;
      });
    });

    userUpdated = Database.onValue('Users').listen((event) {
      setState(() {
        users = event.snapshot.value;
      });
    });

    labelUpdated = Database.onValue('Label').listen((event) {
      setState(() {
        labels = event.snapshot.value;
      });
    });
  }

  // Resets variables and listeners
  void firebaseReset() {
    completeAdded?.cancel();
    userUpdated?.cancel();
    labelUpdated?.cancel();

    users = null;
    labels = null;
    completeData = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ProjectViewer(
                labels: labels == null ? null : labels['epic2'],
                width: 300,
                height: MediaQuery.of(context).size.height,
                epic: 'epic2',
                onTap: (val) async {
                  setState(() {
                    selectedProject = val;
                  });
                }),
            if (users != null)
              Align(
                  alignment: Alignment.centerRight,
                  child: BoardViewer(
                      completedData: completeData,
                      labels: labels == null ? null : labels['epic2'],
                      epic: 'epic2',
                      project: selectedProject,
                      currentUID: currentUID,
                      users: users!,
                      width: MediaQuery.of(context).size.width - 300,
                      height: MediaQuery.of(context).size.height))
          ],
        ));
  }
}
