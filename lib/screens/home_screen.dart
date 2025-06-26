import 'package:flutter/material.dart';
import 'package:project_spacee/screens/solved_screen.dart';
import 'package:provider/provider.dart';
import '../providers/block_provider.dart';
import 'block_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final blocks = Provider.of<BlockProvider>(context).blocks;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1444),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getGreeting(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: blocks.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BlockDetailScreen(block: blocks[index]),
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[300],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Block ${blocks[index].name}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),

          /// Floating Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF2E1A64),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  /// Left & Right Icons
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today_outlined,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SolvedScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.group_outlined,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SolvedScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Floating + Button in Center
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                      offset: const Offset(0, -25),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pinkAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.home_outlined,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}