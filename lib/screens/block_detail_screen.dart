// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/block.dart';
// import '../providers/issue_provider.dart';
// import '../widgets/issue_tile.dart';

// class BlockDetailScreen extends StatelessWidget {
//   final Block block;

//   const BlockDetailScreen({super.key, required this.block});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Block ${block.id}'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Electrical'),
//               Tab(text: 'Plumber'),
//               Tab(text: 'Carpenter'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             IssueTab(category: 'electrical', blockId: block.id),
//             IssueTab(category: 'plumber', blockId: block.id),
//             IssueTab(category: 'carpenter', blockId: block.id),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class IssueTab extends StatelessWidget {
//   final String category;
//   final String blockId;

//   const IssueTab({super.key, required this.category, required this.blockId});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Provider.of<IssueProvider>(context, listen: false)
//           .fetchIssuesByBlockAndCategory(blockId, category),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text('Error loading issues.'));
//         }

//         final issues =
//             Provider.of<IssueProvider>(context).getIssues(blockId, category);

//         final pendingIssues =
//             issues.where((issue) => issue.status != 'Solved').toList();

//         if (pendingIssues.isEmpty) {
//           return const Center(child: Text('No pending issues.'));
//         }

//         return ListView.builder(
//           itemCount: pendingIssues.length,
//           itemBuilder: (ctx, index) {
//             final issue = pendingIssues[index];
//             return IssueTile(
//               blockName: blockId,
//               category: category,
//               issue: issue,
//               index: index,
//             );
//           },
//         );
//       },
//     );
//   }
// }