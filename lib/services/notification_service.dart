import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:intl/intl.dart';
import '../models/lecture_model.dart';
import './database_helper.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});

    await AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      1,
      showDailySummary,
      startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 6),
    );
  }

  static Future<void> scheduleLectureNotifications(List<Lecture> lectures) async {
    for (var lecture in lectures) {
      DateTime now = DateTime.now();
      DateTime lectureTime = DateFormat("HH:mm").parse(lecture.startTime);
      DateTime scheduledTime = DateTime(now.year, now.month, now.day,
          lectureTime.hour, lectureTime.minute);

      if (lecture.day == _getArabicDay(now) && scheduledTime.isAfter(now)) {
        scheduledTime = scheduledTime.subtract(const Duration(minutes: 30));
        int id = lecture.id ?? 0;

        await _notificationsPlugin.zonedSchedule(
          id,
          'محاضرة قادمة ⏰',
          '''
اسم المحاضرة: ${lecture.name}
الوقت: ${lecture.startTime}
الدكتور: ${lecture.doctorName ?? 'غير محدد'}
النوع: ${lecture.type}
المكان: ${lecture.location}
          ''',
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'lecture_channel_id',
              'محاضرات',
              channelDescription: 'إشعارات المحاضرات',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  static Future<void> showDailySummary() async {
    List<Lecture> todayLectures = await DatabaseHelper.instance
        .getLecturesByDay(_getArabicDay(DateTime.now()));

    String title = 'محاضرات اليوم 📚';
    String body = todayLectures.isEmpty
        ? 'لا توجد محاضرات اليوم 🎉'
        : 'لديك ${todayLectures.length} محاضرات اليوم';

    await _notificationsPlugin.show(
      999,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          'ملخص يومي',
          channelDescription: 'إشعار يومي في الساعة 6 صباحًا',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static String _getArabicDay(DateTime date) {
    switch (date.weekday) {
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الاثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      default:
        return 'غير معروف';
    }
  }
}