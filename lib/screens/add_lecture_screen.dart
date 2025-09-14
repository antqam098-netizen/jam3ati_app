import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/lecture_model.dart';
import '../services/database_helper.dart';

class AddLectureScreen extends StatefulWidget {
  final Lecture? lecture;

  const AddLectureScreen({super.key, this.lecture});

  @override
  State<AddLectureScreen> createState() => _AddLectureScreenState();
}

class _AddLectureScreenState extends State<AddLectureScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _doctorController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;
  String _selectedType = 'نظري';
  String _selectedDay = 'السبت';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lecture?.name);
    _doctorController = TextEditingController(text: widget.lecture?.doctorName);
    _locationController = TextEditingController(text: widget.lecture?.location);
    _timeController = TextEditingController(text: widget.lecture?.startTime);
    if (widget.lecture != null) {
      _selectedType = widget.lecture!.type;
      _selectedDay = widget.lecture!.day;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doctorController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.parse('2000-01-01 ${_timeController.text}')),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _saveLecture() async {
    if (_formKey.currentState!.validate()) {
      Lecture lecture = Lecture(
        id: widget.lecture?.id,
        name: _nameController.text.trim(),
        type: _selectedType,
        doctorName: _doctorController.text.trim().isEmpty ? null : _doctorController.text.trim(),
        startTime: _timeController.text,
        location: _locationController.text.trim(),
        day: _selectedDay,
      );

      if (widget.lecture == null) {
        await DatabaseHelper.instance.createLecture(lecture);
      } else {
        await DatabaseHelper.instance.updateLecture(lecture);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lecture == null ? 'إضافة محاضرة جديدة' : 'تعديل المحاضرة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المحاضرة *'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم المحاضرة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'نوع المحاضرة *'),
                items: ['نظري', 'عملي'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(labelText: 'اسم الدكتور (اختياري)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'وقت البدء *'),
                onTap: () => _selectTime(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار وقت البدء';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'مكان الحضور *'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال مكان الحضور';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: const InputDecoration(labelText: 'يوم الأسبوع *'),
                items: [
                  'السبت',
                  'الأحد',
                  'الاثنين',
                  'الثلاثاء',
                  'الأربعاء',
                  'الخميس',
                  'الجمعة'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDay = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveLecture,
                child: const Text('حفظ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}