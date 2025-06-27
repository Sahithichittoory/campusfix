import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>?> addComplaint({
    required String category,
    required String description,
    required String rollNo,
    required String blockNo,
    required String roomNo,
    required String? path,
  }) async {
    try {
      final uri = Uri.parse('http://54.177.10.216:5000/api/addcomplaint');
      final request = http.MultipartRequest('POST', uri)
        ..fields['category'] = category
        ..fields['description'] = description
        ..fields['roll_no'] = rollNo
        ..fields['hostel_block'] = blockNo
        ..fields['room_no'] = roomNo;
      debugPrint(request.fields.toString());
      if (path != null) {
        debugPrint('image is not null');
        request.files.add(await http.MultipartFile.fromPath('image', path));
        print('Image added');
      } else {
        debugPrint('image is null');
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print("Response Body: $responseBody");

      if (streamedResponse.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        return {
          'status': false,
          'message': 'Server Error ${streamedResponse.statusCode}'
        };
      }
    } catch (e) {
      print("API Exception: $e");
      return {'status': false, 'message': 'Error submitting form'};
    }
  }
}