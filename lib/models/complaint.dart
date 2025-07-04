
class Complaint {
  final String id;
  final String category;
  final String description;
  final String image;
  final String rollNo;
  final String hostelBlock;
  final String roomNo;
  String status;
  final String createdAt;
  final String updatedAt;

  Complaint({
    required this.id,
    required this.category,
    required this.description,
    required this.image,
    required this.rollNo,
    required this.hostelBlock,
    required this.roomNo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      category: json['category'],
      description: json['description'],
      image: json['image'],
      rollNo: json['roll_no'],
      hostelBlock: json['hostel_block'],
      roomNo: json['room_no'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
