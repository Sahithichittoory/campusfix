import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/issue.dart';
import '../providers/block_provider.dart';

class IssueTile extends StatelessWidget {
  final String blockName;
  final String category;
  final Issue issue;
  final int index;

  const IssueTile({super.key,
    required this.blockName,
    required this.category,
    required this.issue,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: issue.status == 'Solved' ? Colors.green[100] : Colors.red[100],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room: ${issue.roomNumber}'),
            Text('Floor: ${issue.floor}'),
            Text('Issue: ${issue.shortDescription}'),
            const SizedBox(height: 5),
            ExpansionTile(
              title: const Text("View Details"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(issue.detailedDescription),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BlockProvider>(context, listen: false)
                        .updateIssueStatus(
                        blockName, category, index, 'Solved');
                  },
                  child: const Text('Solved'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    Provider.of<BlockProvider>(context, listen: false)
                        .updateIssueStatus(
                        blockName, category, index, 'Pending');
                  },
                  child: const Text('Pending'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}