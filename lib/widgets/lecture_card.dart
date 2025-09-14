import 'package:flutter/material.dart';
import '../models/lecture_model.dart';

class LectureCard extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const LectureCard({
    super.key,
    required this.lecture,
    this.onDelete,
    this.onEdit,
  });

  Color _getTypeColor() {
    return lecture.type == 'نظري' ? Colors.blue : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _getTypeColor().withOpacity(0.1),
      child: ListTile(
        leading: Icon(
          lecture.type == 'نظري' ? Icons.menu_book : Icons.science,
          color: _getTypeColor(),
        ),
        title: Text(lecture.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الوقت: ${lecture.startTime}'),
            if (lecture.doctorName != null) Text('الدكتور: ${lecture.doctorName}'),
            Text('المكان: ${lecture.location}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}