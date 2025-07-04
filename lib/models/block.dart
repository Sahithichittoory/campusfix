class Block {
  final String id;
  final int count;

  Block({required this.id, required this.count});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['_id'],
      count: json['count'],
    );
  }
}