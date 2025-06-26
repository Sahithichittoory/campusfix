import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/block.dart';
import '../providers/block_provider.dart';
import '../widgets/issue_tile.dart';

class BlockDetailScreen extends StatelessWidget {
  final Block block;

  const BlockDetailScreen({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Block ${block.name}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Electrical'),
              Tab(text: 'Plumber'),
              Tab(text: 'Carpenter'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IssueTab(category: 'electrical', blockName: block.name),
            IssueTab(category: 'plumber', blockName: block.name),
            IssueTab(category: 'carpenter', blockName: block.name),
          ],
        ),
      ),
    );
  }
}

class IssueTab extends StatelessWidget {
  final String category;
  final String blockName;

  const IssueTab({super.key, required this.category, required this.blockName});

  @override
  Widget build(BuildContext context) {
    return Consumer<BlockProvider>(
      builder: (ctx, blockProvider, _) {
        final block =
        blockProvider.blocks.firstWhere((b) => b.name == blockName);
        final issues = block.issues[category] ?? [];

        final pendingIssues = issues
            .asMap()
            .entries
            .where((entry) => entry.value.status != 'Solved')
            .toList();

        if (pendingIssues.isEmpty) {
          return const Center(child: Text('No pending issues.'));
        }

        return ListView.builder(
          itemCount: pendingIssues.length,
          itemBuilder: (ctx, index) {
            final issueIndex = pendingIssues[index].key;
            final issue = pendingIssues[index].value;

            return IssueTile(
              blockName: blockName,
              category: category,
              issue: issue,
              index: issueIndex,
            );
          },
        );
      },
    );
  }
}