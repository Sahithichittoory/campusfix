import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/block_provider.dart';

class SolvedScreen extends StatelessWidget {
  const SolvedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blockProvider = Provider.of<BlockProvider>(context);
    final solvedIssues = blockProvider.getAllSolvedIssues();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Solved Issues"),
        backgroundColor: Colors.deepPurple,
      ),
      body: solvedIssues.isEmpty
          ? const Center(
        child: Text(
          "No issues marked as solved yet.",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        itemCount: solvedIssues.length,
        itemBuilder: (ctx, index) {
          final issueData = solvedIssues[index];

          return Stack(
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                color: Colors.green[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Block: ${issueData.blockName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text('Category: ${issueData.category}'),
                      Text('Room: ${issueData.issue.roomNumber}'),
                      Text('Floor: ${issueData.issue.floor}'),
                      Text('Issue: ${issueData.issue.shortDescription}'),
                      const SizedBox(height: 6),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text(
                          "View Details",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child:
                            Text(issueData.issue.detailedDescription),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ✅ SOLVED Stamp
              Positioned(
                top: 10,
                right: 20,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "SOLVED",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}