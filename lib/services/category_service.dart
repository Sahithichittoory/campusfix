import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/category_count.dart';

class CategoryCountProvider with ChangeNotifier {
  List<CategoryCount> _counts = [];

  List<CategoryCount> get counts => _counts;

  Future<Map<String, int>> fetchCategoryCounts(String blockId) async {
    final response = await http.post(
      Uri.parse("http://54.177.10.216:5000/api/complaints/category/count"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"block": blockId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Remove the message
      data.remove("message");

      // Convert list of complaints to their count
      return data.map((key, value) => MapEntry(key, (value as List).length));
    } else {
      throw Exception("Failed to load category counts");
    }
  }

  int getCountByCategory(String category) {
    return _counts
        .firstWhere((c) => c.category.toLowerCase() == category.toUpperCase(),
        orElse: () => CategoryCount(category: category, count: 0))
        .count;
  }
}