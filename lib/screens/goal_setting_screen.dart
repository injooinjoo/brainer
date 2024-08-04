// lib/screens/goal_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../providers/exam_provider.dart';
import '../models/exam.dart';

class GoalSettingScreen extends StatefulWidget {
  final Goal? goal;

  const GoalSettingScreen({Key? key, this.goal}) : super(key: key);

  @override
  _GoalSettingScreenState createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  String? _examId;
  DateTime? _examDate;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _title = widget.goal!.title;
      _description = widget.goal!.description;
      _dueDate = widget.goal!.dueDate;
      _examId = widget.goal!.examId.isEmpty ? null : widget.goal!.examId;
      _examDate = widget.goal!.examDate;
    } else {
      _title = '';
      _description = '';
      _dueDate = DateTime.now().add(Duration(days: 7));
      _examId = null;
      _examDate = null;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final goal = Goal(
        id: widget.goal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        dueDate: _dueDate,
        isCompleted: widget.goal?.isCompleted ?? false,
        examId: _examId ?? '',
        examDate: _examDate,
      );
      Navigator.pop(context, goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);
    final exams = [
      Exam(
          id: 'toefl',
          name: 'TOEFL',
          description: 'Test of English as a Foreign Language'),
      Exam(id: 'sat', name: 'SAT', description: 'Scholastic Assessment Test'),
      Exam(id: 'realtor', name: '공인중개사', description: '공인중개사 자격증 시험'),
      ...examProvider.exams,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Set a New Goal' : 'Edit Goal'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              DropdownButtonFormField<String?>(
                value: _examId,
                decoration: InputDecoration(
                  labelText: 'Exam',
                  labelStyle: TextStyle(color: Colors.red),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('없음'),
                  ),
                  ...exams.map((exam) {
                    return DropdownMenuItem(
                      value: exam.id,
                      child: Text(exam.name),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    _examId = value;
                  });
                },
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
              ElevatedButton(
                child: Text('Select Due Date'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null && picked != _dueDate) {
                    setState(() {
                      _dueDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                  'Exam Date: ${_examDate?.toLocal().toString().split(' ')[0] ?? 'Not set'}'),
              ElevatedButton(
                child: Text('Select Exam Date'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _examDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null && picked != _examDate) {
                    setState(() {
                      _examDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  child: Text(widget.goal == null ? 'Set Goal' : 'Update Goal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
