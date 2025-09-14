import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/lecture_model.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';
import '../widgets/lecture_card.dart';
import 'add_lecture_screen.dart';
import 'about_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Lecture>> _lecturesFuture;

  @override
  void initState() {
    super.initState();
    _refreshLectures();
  }

  Future<void> _refreshLectures() async {
    setState(() {
      _lecturesFuture = DatabaseHelper.instance.getLectures();
    });
    List<Lecture> lectures = await _lecturesFuture;
    await NotificationService.scheduleLectureNotifications(lectures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جامعتي 🎓'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Lecture>>(
        future: _lecturesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Lecture> lectures = snapshot.data!;
            return ListView(
              children: [
                ..._buildDaySection('السبت', lectures),
                ..._buildDaySection('الأحد', lectures),
                ..._buildDaySection('الاثنين', lectures),
                ..._buildDaySection('الثلاثاء', lectures),
                ..._buildDaySection('الأربعاء', lectures),
                ..._buildDaySection('الخميس', lectures),
                ..._buildDaySection('الجمعة', lectures),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLectureScreen()),
          );
          if (result == true) {
            _refreshLectures();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildDaySection(String day, List<Lecture> lectures) {
    List<Lecture> dayLectures = lectures.where((l) => l.day == day).toList();
    if (dayLectures.isEmpty) return [];

    return [
      Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(8),
        child: Text(
          day,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ...dayLectures.map((lecture) => LectureCard(
            lecture: lecture,
            onDelete: () async {
              await DatabaseHelper.instance.deleteLecture(lecture.id!);
              Fluttertoast.showToast(msg: 'تم حذف المحاضرة');
              _refreshLectures();
            },
            onEdit: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLectureScreen(lecture: lecture),
                ),
              );
              if (result == true) {
                _refreshLectures();
              }
            },
          )),
    ];
  }
}