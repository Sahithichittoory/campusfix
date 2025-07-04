import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart'; // Using debugPrint from here
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
      final uri = Uri.parse('http://54.177.10.216:5000/api/addcomplaint'); // Ensure this IP is stable and accessible

      final request = http.MultipartRequest('POST', uri)
        ..fields['category'] = category
        ..fields['description'] = description
        ..fields['roll_no'] = rollNo
        ..fields['hostel_block'] = blockNo
        ..fields['room_no'] = roomNo;

      debugPrint('Request Fields: ${request.fields}'); // Use debugPrint consistently

      if (path != null && path.isNotEmpty) { // Added path.isNotEmpty check
        File imageFile = File(path);
        if (await imageFile.exists()) { // Check if file actually exists
          request.files.add(await http.MultipartFile.fromPath('image', path));
          debugPrint('Image file added to request.');
        } else {
          debugPrint('Image file does not exist at path: $path');
          // You might want to return an error here or proceed without image
          // For now, it will proceed without the image if file not found
        }
      } else {
        debugPrint('Image path is null or empty. No image uploaded.');
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      debugPrint("API Response Status Code: ${streamedResponse.statusCode}");
      debugPrint("API Response Body: $responseBody"); // Log the raw response body

      if (streamedResponse.statusCode == 200) {
        final decodedResponse = json.decode(responseBody);

        // --- CRITICAL CHANGE HERE ---
        // Check if 'status' exists and convert it to a boolean explicitly
        // This handles cases where backend sends "true", "True", or actual boolean true
        bool isSuccess = false;
        if (decodedResponse.containsKey('status')) {
          final dynamic statusValue = decodedResponse['status'];
          if (statusValue is bool) {
            isSuccess = statusValue;
          } else if (statusValue is String) {
            isSuccess = (statusValue.toLowerCase() == 'true');
          }
          // You can add more checks here if your backend sends other types for status
        }

        // Return a standardized map with a boolean status
        return {
          'status': isSuccess,
          'message': decodedResponse['message'] ?? 'No message provided',
          // You can pass other relevant data from decodedResponse here if needed
        };
      } else {
        // Handle non-200 responses
        String errorMessage = 'Server Error ${streamedResponse.statusCode}';
        try {
          final errorResponse = json.decode(responseBody);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (decodeError) {
          debugPrint('Failed to decode error response: $decodeError');
        }
        return {'status': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint("API Exception: $e"); // Use debugPrint for exceptions
      return {'status': false, 'message': 'Error submitting form. Exception: $e'}; // Include exception for debugging
    }
  }
}