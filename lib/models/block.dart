import 'issue.dart';

class Block {
  final String name;
  final Map<String, List<Issue>> issues;

  Block({required this.name, required this.issues});
}