import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import 'local__notifications__service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(currentTimeZone));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  DateTime? dateTime;
  void _incrementCounter() async {
    final NotificationService notificationService = NotificationService();
    notificationService.init();
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    print('date: $date');
    if (mounted) {
      var time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: DateTime.now().hour, minute: DateTime.now().minute));
      dateTime =
          DateTime(date!.year, date.month, date.day, time!.hour, time.minute);
      print('date: $date');
      print('dateTime: $dateTime');
    }
    // Get difference between the current date and the notification date
    Duration difference = dateTime!.difference(DateTime.now());
    // and add it to box
    int newId = Random().nextInt(1000000);
    notificationService.createScheduledNotification(
      newId,
      'title',
      'description',
      tz.TZDateTime.now(tz.local).add(
        Duration(
          seconds: difference.inSeconds,
        ),
      ),
      "$newId",
      true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              dateTime.toString(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
