
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/complaint.dart';

Future<List<Complaint>> fetchComplaints(String block, String category) async {
  final url = Uri.parse('http://54.177.10.216:5000/api/complaints');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'hostel_block': block, 'category': category}),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    // Make sure to extract 'data' from the response
    final List<dynamic> complaintsJson = jsonBody['data'];

    return complaintsJson.map((json) => Complaint.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load complaints');
  }
}

Future<void> updateComplaintStatus(String id, String status) async {
  final url = Uri.parse('http://54.177.10.216:5000/api/complaints/update/$id');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'status': status}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update status');
  }
}
