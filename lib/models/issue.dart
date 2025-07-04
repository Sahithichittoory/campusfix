class Issue {
  String roomNumber;
  String floor;
  String shortDescription;
  String detailedDescription;
  String status;

  Issue({
    required this.roomNumber,
    required this.floor,
    required this.shortDescription,
    required this.detailedDescription,
    this.status = 'Pending',
  });
}