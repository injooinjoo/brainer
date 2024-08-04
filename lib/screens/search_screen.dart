// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    // TODO: Load search history from local storage
  }

  void _addSearchTerm(String term) {
    setState(() {
      _searchHistory.insert(0, term);
      // TODO: Save search history to local storage
    });
  }

  void _deleteSearchTerm(String term) {
    setState(() {
      _searchHistory.remove(term);
      // TODO: Save search history to local storage
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for quizzes',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _addSearchTerm(value);
              _searchController.clear();
              // TODO: Implement search functionality
            }
          },
        ),
      ),
      body: Column(
        children: [
          _buildFilterOptions(quizProvider),
          Expanded(
            child: ListView.builder(
              itemCount: quizProvider.filteredQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizProvider.filteredQuizzes[index];
                return ListTile(
                  title: Text(quiz.title),
                  subtitle: Text(
                      'Category: ${quiz.category}, Difficulty: ${quiz.difficulty}'),
                  onTap: () {
                    // TODO: Navigate to quiz detail screen
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(QuizProvider quizProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                  quizProvider.setCategory(_selectedCategory);
                });
              },
              items: ['All', 'Math', 'Science', 'History', 'Literature']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedDifficulty,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDifficulty = newValue!;
                  quizProvider.setDifficulty(_selectedDifficulty);
                });
              },
              items: ['All', 'Easy', 'Medium', 'Hard']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
