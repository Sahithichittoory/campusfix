import 'dart:ui';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEC5F6),
      body: Stack(
        children: [
          /// Gradient header background
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC562AF), Color(0xFFB33791)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Main content
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: const [
                      NotificationTile(
                        title: "Issue Update",
                        subtitle: "Your electrical issue is resolved.",
                      ),
                      NotificationTile(
                        title: "New Announcement",
                        subtitle: "Hostel cleaning scheduled for Friday.",
                      ),
                      NotificationTile(
                        title: "Reminder",
                        subtitle: "Don't forget to update your room info.",
                      ),
                      NotificationTile(
                        title: "Feedback",
                        subtitle: "We value your opinion! Give feedback now.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 212, 105, 141).withOpacity(0.2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white30),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}