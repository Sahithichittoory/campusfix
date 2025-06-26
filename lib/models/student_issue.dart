class Issue {
  final String roomNumber;
  final String description;
  final DateTime timestamp;
  bool isSolved;

  Issue({
    required this.roomNumber,
    required this.description,
    required this.timestamp,
    this.isSolved = false,
  });
}