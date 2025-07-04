import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/block.dart';

class BlockProvider with ChangeNotifier {
  List<Block> _blocks = [];

  List<Block> get blocks => _blocks;

  Future<void> fetchBlocksWithComplaints() async {
    final url = Uri.parse(
        'http://54.177.10.216:5000/api/complaints/count'); // Replace with your API

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _blocks = data.map((json) => Block.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load blocks');
      }
    } catch (e) {
      print('Error fetching blocks: $e');
    }
  }
}