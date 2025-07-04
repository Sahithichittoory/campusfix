import 'package:flutter/material.dart';
import '../models/student_issue.dart';

class IssueProvider with ChangeNotifier {
  final List<Issue> _issues = [];

  List<Issue> get issues => [..._issues];
  List<Issue> get pendingIssues => _issues.where((i) => !i.isSolved).toList();
  List<Issue> get solvedIssues => _issues.where((i) => i.isSolved).toList();

  void addIssue(Issue issue) {
    _issues.add(issue);
    notifyListeners();
  }

  void submitIssue({
    required String roomNumber,
    required String description,
  }) {
    final issue = Issue(
      roomNumber: roomNumber,
      description: description,
      timestamp: DateTime.now(),
      isSolved: false,
    );
    addIssue(issue);
  }

  void toggleIssueStatus(Issue issue) {
    final index = _issues.indexOf(issue);
    if (index != -1) {
      _issues[index].isSolved = !_issues[index].isSolved;
      notifyListeners();
    }
  }

  void deleteIssue(Issue issue) {
    _issues.remove(issue);
    notifyListeners();
  }

  fetchIssuesByBlockAndCategory(String blockId, String category) {}

  getIssues(String blockId, String category) {}
}