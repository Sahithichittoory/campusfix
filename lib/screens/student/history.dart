
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final String category;
  final String description;
  final String imageData;

  const History({
    super.key,
    required this.category,
    required this.description,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? decodedImage;

    // Decode base64 image string safely
    try {
      if (imageData.isNotEmpty) {
        decodedImage = base64Decode(imageData);
      }
    } catch (e) {
      decodedImage = null;
    }

    final bool hasComplaint =
        category.isNotEmpty || description.isNotEmpty || imageData.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: hasComplaint
          ? ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Issue Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8854D0),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Category: $category",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description,
                        color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Description: $description",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (decodedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      decodedImage,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ],
      )
          : const Center(
        child: Text(
          "No complaints submitted yet.",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
