import 'package:flutter/material.dart';
import '../models/block.dart';
import '../models/issue.dart';
import '../models/issue_data.dart';
import 'issue_provider.dart';

class BlockProvider with ChangeNotifier {
  List<Block> _blocks = [];

  List<Block> get blocks => _blocks;

  BlockProvider() {
    loadInitialData();
  }

  void loadInitialData() {
    _blocks = [
      Block(
        name: 'A',
        issues: {
          'electrical': [
            Issue(
              roomNumber: '101',
              floor: '1',
              shortDescription: 'Light not working',
              detailedDescription: 'Tube light not turning on since morning.',
            ),
          ],
          'plumber': [
            Issue(
              roomNumber: '102',
              floor: '1',
              shortDescription: 'Leaking tap',
              detailedDescription: 'Tap is continuously leaking in washroom.',
            ),
          ],
          'carpenter': [],
        },
      ),
      Block(
        name: 'B',
        issues: {
          'electrical': [],
          'plumber': [],
          'carpenter': [
            Issue(
              roomNumber: '201',
              floor: '2',
              shortDescription: 'Broken chair',
              detailedDescription: 'Chair leg broken in room.',
            ),
          ],
        },
      ),
    ];
    notifyListeners();
  }

  void updateIssueStatus(
      String blockName, String category, int index, String newStatus) {
    final block = _blocks.firstWhere((b) => b.name == blockName);
    block.issues[category]![index].status = newStatus;
    notifyListeners();
  }
  List<IssueData> getAllSolvedIssues() {
    List<IssueData> solved = [];

    for (var block in _blocks) {
      for (var category in block.issues.keys) {
        for (var issue in block.issues[category]!) {
          if (issue.status == 'Solved') {
            solved.add(IssueData(
              blockName: block.name,
              category: category,
              issue: issue,
            ));
          }
        }
      }
    }

    return solved;
  }
}