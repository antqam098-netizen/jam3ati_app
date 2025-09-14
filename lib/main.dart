import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'services/database_helper.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
    "daily-summary",
    "showDailySummary",
    frequency: const Duration(hours: 24),
    initialDelay: _calculateDelayToSixAM(),
  );

  await NotificationService.initialize();
  runApp(const MyApp());
}


Duration _calculateDelayToSixAM() {
  final now = DateTime.now();
  final sixAM = DateTime(now.year, now.month, now.day, 6);
  if (now.hour >= 6) {
    sixAM.add(const Duration(days: 1));
  }
  return sixAM.difference(now);
}


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "showDailySummary":
        await NotificationService.showDailySummary();
        break;
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جامعتي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

