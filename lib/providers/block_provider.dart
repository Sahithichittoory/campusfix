import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/block.dart';

class BlockProvider with ChangeNotifier {
  List<Block> _blocks = [];

  List<Block> get blocks => _blocks;

  Future<void> fetchBlocksWithComplaints() async {
    final url = Uri.parse('http://54.177.10.216:5000/api/complaints/count');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        final List<dynamic> blockData = extractedData['data'];

        _blocks = blockData.map((b) => Block.fromJson(b)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load blocks');
      }
    } catch (error) {
      print('Error fetching blocks: $error');
      rethrow;
    }
  }

  getAllSolvedIssues() {}

  void updateIssueStatus(
      String blockName, String category, int index, String s) {}
}