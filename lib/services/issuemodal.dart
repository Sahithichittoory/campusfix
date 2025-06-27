
// models/issue_model.dart
import 'dart:typed_data';

class IssueModel {
  final String category;
  final String description;
  final Uint8List? imageBytes;

  IssueModel({
    required this.category,
    required this.description,
    required this.imageBytes,
  });
}
