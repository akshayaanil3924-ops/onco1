import 'package:flutter/material.dart';
import 'screens/online_consultation_screen.dart';
import 'screens/view_reports_screen.dart';
import 'screens/homestay_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/awareness_screen.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  final Color deepBlue = const Color(0xFF0D47A1);
  final Color accentBlue = const Color.fromARGB(255, 70, 100, 150);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 🚫 Disable system back
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,

          // 🚫 Disable top-left back arrow
          automaticallyImplyLeading: false,

          // 🔹 APP TITLE
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.volunteer_activism,
                size: 22,
                color: accentBlue,
              ),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Onco',
                      style: TextStyle(
                        color: deepBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: 'Soul',
                      style: TextStyle(
                        color: accentBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🔹 LOGOUT BUTTON (BLUE)
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: deepBlue, // ✅ changed from red to blue
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text(
                      'Are you sure you want to logout?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                          );
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey..',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: deepBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'We’re here to support your care journey',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: [
                    optionBox(
                      context,
                      icon: Icons.video_call_outlined,
                      title: 'Online Consultation',
                      subtitle: 'Consult doctors',
                      color: Colors.blue.shade700,
                      screen: OnlineConsultationScreen(),
                    ),
                    optionBox(
                      context,
                      icon: Icons.description_outlined,
                      title: 'View Reports',
                      subtitle: 'Access your medical reports',
                      color: Colors.teal.shade700,
                      screen: ViewReportsScreen(),
                    ),
                    optionBox(
                      context,
                      icon: Icons.home_outlined,
                      title: 'Accomodation',
                      subtitle: 'Find nearby stays',
                      color: Colors.brown.shade700,
                      screen: HomestayScreen(),
                    ),
                    optionBox(
                      context,
                      icon: Icons.people_outline,
                      title: 'Community Forum',
                      subtitle: 'Connect with other patients',
                      color: Colors.purple.shade700,
                      screen: CommunityForumScreen(),
                    ),
                    optionBox(
                      context,
                      icon: Icons.health_and_safety_outlined,
                      title: 'Awareness',
                      subtitle: 'Learn about cancer care',
                      color: Colors.green.shade700,
                      screen: AwarenessScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 OPTION BOX
  Widget optionBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget screen,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.20),
                ),
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
