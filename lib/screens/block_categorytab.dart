import 'package:flutter/material.dart';
import 'package:project_spacee/models/complaint.dart';
import 'package:project_spacee/screens/solved_screen.dart';
import 'package:project_spacee/services/category_service.dart';
import 'package:project_spacee/services/complaint_service.dart';
import 'package:provider/provider.dart';

class BlockCategoryTabsScreen extends StatefulWidget {
  final String blockId;

  const BlockCategoryTabsScreen({super.key, required this.blockId});

  @override
  State<BlockCategoryTabsScreen> createState() =>
      _BlockCategoryTabsScreenState();
}

class _BlockCategoryTabsScreenState extends State<BlockCategoryTabsScreen> {
  final List<String> categories = [
    'Electricity',
    'Plumbing',
    'Food',
    'Furniture',
    'Wi-Fi',
    'Others',
  ];

  final Map<String, Future<List<Complaint>>> _categoryFutures = {};

  @override
  void initState() {
    super.initState();
    for (String category in categories) {
      _categoryFutures[category] = fetchComplaints(widget.blockId, category);
    }

    Future.microtask(() {
      Provider.of<CategoryCountProvider>(context, listen: false)
          .fetchCategoryCounts(widget.blockId);
    });
  }

  void _refreshCategory(String category) {
    setState(() {
      _categoryFutures[category] = fetchComplaints(widget.blockId, category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Block ${widget.blockId} Complaints'),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((category) {
            return FutureBuilder<List<Complaint>>(
              future: _categoryFutures[category],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final complaints = snapshot.data!;
                if (complaints.isEmpty) {
                  return const Center(child: Text('No complaints found.'));
                }

                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category: ${complaint.category}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text('Description: ${complaint.description}'),
                            Text('Room: ${complaint.roomNo}'),
                            Text('Roll No: ${complaint.rollNo}'),
                            const SizedBox(height: 6),
                            Text(
                              'Status: ${complaint.status}',
                              style: TextStyle(
                                color: complaint.status == 'Solved'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.35,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await updateComplaintStatus(
                                          complaint.id, 'Solved');

                                      _refreshCategory(
                                          category); // Remove from tab

                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const SolvedScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    child: const Text('Solved',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.35,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await updateComplaintStatus(
                                          complaint.id, 'Pending');
                                      _refreshCategory(category);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[700],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    child: const Text('Pending',
                                        style: TextStyle(fontSize: 16)),
                                  ),
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
            );
          }).toList(),
        ),
      ),
    );
  }
}