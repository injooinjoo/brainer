// lib/screens/goal_setting_screen.dart

import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalSettingScreen extends StatefulWidget {
  final Goal? goal; // Add this line

  const GoalSettingScreen({Key? key, this.goal})
      : super(key: key); // Modify this line

  @override
  _GoalSettingScreenState createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _title = widget.goal!.title;
      _description = widget.goal!.description;
      _dueDate = widget.goal!.dueDate;
    } else {
      _title = '';
      _description = '';
      _dueDate = DateTime.now().add(Duration(days: 7));
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
      );
      Navigator.pop(context, goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Set a New Goal' : 'Edit Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Goal Title'),
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
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 20),
              Text('Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
              ElevatedButton(
                child: Text('Select Due Date'),
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
              Center(
                child: ElevatedButton(
                  child: Text(widget.goal == null ? 'Set Goal' : 'Update Goal'),
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
