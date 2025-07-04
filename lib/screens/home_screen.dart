
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_spacee/screens/admin_screen.dart';
import 'package:project_spacee/screens/block_categorytab.dart';
import 'package:project_spacee/screens/solved_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/block_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String adminName = '';
  String adminId = '';
  String adminEmail = '';
  String adminMobile = '';

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    Future.delayed(Duration.zero, () async {
      await Provider.of<BlockProvider>(context, listen: false)
          .fetchBlocksWithComplaints();
    });
  }

  Future<void> _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? '';
      adminId = prefs.getString('adminId') ?? '';
      adminEmail = prefs.getString('adminEmail') ?? '';
      adminMobile = prefs.getString('adminMobile') ?? '';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final blocks = Provider.of<BlockProvider>(context).blocks;

    List<Widget> screens = [
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
                  color: Color(0xFF2E1A64),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: blocks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: blocks.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlockCategoryTabsScreen(
                            blockId: blocks[index].id),
                      ),
                    );
                  },
                  child: Container(
                    height: 130,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC562AF), Color(0xFFB33791)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Block ${blocks[index].id}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${blocks[index].count} Complaints',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      const SolvedScreen(),
      const AdminProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFEC5F6), Color(0xFFDB8DD0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: _selectedIndex == 1
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                                onPressed: () => _onItemTapped(1),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.person_outlined,
                                  color: _selectedIndex == 2
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                                onPressed: () => _onItemTapped(2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform.translate(
                          offset: const Offset(0, 1),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFB33791),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.home_outlined,
                                  color: Colors.white),
                              onPressed: () => _onItemTapped(0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
