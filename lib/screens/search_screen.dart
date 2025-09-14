import 'package:flutter/material.dart';
import '../models/lecture_model.dart';
import '../services/database_helper.dart';
import '../widgets/lecture_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Lecture> _results = [];

  Future<void> _search() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    List<Lecture> results = await DatabaseHelper.instance.searchLectures(_searchController.text);
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بحث سريع')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'ابحث باسم المحاضرة، الدكتور، المكان، أو النوع',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('أدخل نصًا للبحث...'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      return LectureCard(lecture: _results[index], onDelete: null, onEdit: null);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}