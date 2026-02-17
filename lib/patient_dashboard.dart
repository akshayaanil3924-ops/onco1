import 'package:flutter/material.dart';
import 'screens/online_consultation_screen.dart';
import 'screens/view_reports_screen.dart';
import 'screens/homestay_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/awareness_screen.dart';
import 'services/notification_service.dart';
import 'widgets/notification_panel.dart';
import 'login.dart';

class PatientDashboard extends StatefulWidget {
  final String userName;

  const PatientDashboard({
    super.key,
    required this.userName,
  });

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  static const Color primaryBlue = Color(0xFF1E5AA8);
  final _notifService = NotificationService.instance;

  @override
  void initState() {
    super.initState();
    _notifService.addListener(_refresh);
  }

  @override
  void dispose() {
    _notifService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _showNotificationPanel(BuildContext context) {
    _notifService.markAllPatientRead();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(ctx).padding.top + 64,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: ListenableBuilder(
                  listenable: _notifService,
                  builder: (_, __) => NotificationPanel(
                    notifications: _notifService.patientNotifications,
                    onMarkAllRead: _notifService.markAllPatientRead,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double bannerHeight = screenWidth < 600 ? 220 : screenWidth < 1100 ? 250 : 280;
    double titleSize = screenWidth < 600 ? 26 : screenWidth < 1100 ? 30 : 34;
    double subtitleSize = screenWidth < 600 ? 14 : screenWidth < 1100 ? 16 : 17;
    final unreadCount = _notifService.patientUnreadCount;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 213, 230, 243),
              Color.fromARGB(255, 192, 213, 236),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // ── HEADER ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // Logo
                      Row(
                        children: const [
                          Icon(Icons.volunteer_activism, color: primaryBlue),
                          SizedBox(width: 6),
                          Text(
                            "OncoSoul",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 4, 46, 100),
                            ),
                          ),
                        ],
                      ),

                      // Right side: Bell + Logout + Avatar
                      Row(
                        children: [

                          // 🔔 Notification Bell
                          GestureDetector(
                            onTap: () => _showNotificationPanel(context),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(Icons.notifications_none, size: 28),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),

                          // 🚪 Logout Button
                          GestureDetector(
                            onTap: () => _logout(context),
                            child: const Icon(
                              Icons.logout,
                              size: 26,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // 👤 User name + Avatar
                          Text(
                            widget.userName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage("assets/images/profile.png"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── HERO BANNER ──────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  height: bannerHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            "assets/images/dashboard_bg.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 205, 241, 239).withValues(alpha: 0.9),
                                  const Color.fromARGB(255, 239, 250, 247).withValues(alpha: 0.6),
                                  const Color.fromARGB(255, 239, 247, 244).withValues(alpha: 0.1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hello, ${widget.userName}",
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "We're here to support your care journey",
                                style: TextStyle(fontSize: subtitleSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── OPTION CARDS ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: _card(
                              context,
                              Icons.video_call,
                              "Online Consultation",
                              const OnlineConsultationScreen(),
                              const Color.fromARGB(255, 12, 58, 150),
                              const Color.fromARGB(255, 148, 171, 211),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _card(
                              context,
                              Icons.description,
                              "View Reports",
                              const ViewReportsScreen(),
                              const Color.fromARGB(255, 3, 124, 68),
                              const Color.fromARGB(255, 127, 219, 142),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: _card(
                              context,
                              Icons.home,
                              "Accommodation",
                              const HomestayScreen(),
                              const Color.fromARGB(255, 207, 111, 32),
                              const Color.fromARGB(255, 238, 197, 151),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _card(
                              context,
                              Icons.people,
                              "Community Forum",
                              const CommunityForumScreen(),
                              const Color.fromARGB(255, 126, 115, 14),
                              const Color.fromARGB(255, 234, 245, 137),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: _card(
                              context,
                              Icons.health_and_safety,
                              "Awareness",
                              const AwarenessScreen(),
                              const Color.fromARGB(255, 196, 39, 117),
                              const Color.fromARGB(255, 218, 137, 161),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen,
    Color iconColor,
    Color circleColor,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 229, 238, 240).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}