import 'package:flutter/material.dart';
import 'package:project_spacee/services/complaint_service.dart';
import '../models/complaint.dart';

class ComplaintScreen extends StatelessWidget {
  final String block;
  final String category;
  final Future<List<Complaint>> complaintsFuture;

  const ComplaintScreen({
    super.key,
    required this.block,
    required this.category,
    required this.complaintsFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${category.toUpperCase()} Complaints')),
      body: FutureBuilder<List<Complaint>>(
        future: complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final complaints = snapshot.data ?? [];

          if (complaints.isEmpty) {
            return const Center(child: Text('No complaints found.'));
          }

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${complaint.category}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Description: ${complaint.description}'),
                      Text('Room: ${complaint.roomNo}'),
                      Text('Roll No: ${complaint.rollNo}'),
                      Text('Status: ${complaint.status}',
                          style: TextStyle(
                            color: complaint.status == 'Solved'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await updateComplaintStatus(
                                  complaint.id, 'Solved');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Marked as Solved')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text('Mark as Solved'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await updateComplaintStatus(
                                  complaint.id, 'Pending');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Marked as Pending')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: const Text('Mark as Pending'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}