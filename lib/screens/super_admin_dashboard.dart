import 'package:flutter/material.dart';
import '../login.dart';

import 'admin_awareness_management_screen.dart';
import 'admin_homestay_management_screen.dart';

import '../models/user_model.dart';
import '../models/homestay_model.dart';
import '../models/awareness_model.dart';
import 'package:fl_chart/fl_chart.dart';


class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  final Color deepBlue = const Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Super Administration",
            style: TextStyle(
              color: Color(0xFF0D47A1),
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFF0D47A1)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [

              // ================= CONTENT =================
              sectionTitle("Content Management"),

              optionBox(
                context,
                icon: Icons.health_and_safety_outlined,
                title: "Awareness Content",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminAwarenessManagementScreen(),
                    ),
                  );
                },
              ),

              optionBox(
                context,
                icon: Icons.home_work_outlined,
                title: "Accommodation",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminHomestayManagementScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // ================= ANALYTICS =================
              sectionTitle("System Analytics"),

              analyticsBox(),

              const SizedBox(height: 30),

              // ================= SYSTEM =================
              sectionTitle("System Controls"),

              optionBox(
                context,
                icon: Icons.settings_backup_restore,
                title: "Reset System",
                onTap: () {
                  UserData.users.clear();
                  HomestayData.homestays.clear();
                  AwarenessData.contents.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("System Reset Completed"),
                    ),
                  );
                },
              ),

              optionBox(
                context,
                icon: Icons.backup,
                title: "Backup Data",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Backup Created Successfully"),
                    ),
                  );
                },
              ),

              optionBox(
                context,
                icon: Icons.admin_panel_settings_outlined,
                title: "Manage Roles",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Role Management Coming Soon"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }

  // ================= OPTION BOX =================
  Widget optionBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ANALYTICS BOX =================
  Widget analyticsBox() {
  int totalPatients =
      UserData.users.where((u) => u.role == 'Patient').length;

  int totalDoctors =
      UserData.users.where((u) => u.role == 'Doctor').length;

  int activeUsers =
      UserData.users.where((u) => u.isActive).length;

  int totalBookings = 0; // Add real model later
  int totalPosts = 0;    // Add real model later

  return Container(
    height: 300,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Patients', style: TextStyle(fontSize: 10));
                  case 1:
                    return const Text('Doctors', style: TextStyle(fontSize: 10));
                  case 2:
                    return const Text('Posts', style: TextStyle(fontSize: 10));
                  case 3:
                    return const Text('Bookings', style: TextStyle(fontSize: 10));
                  case 4:
                    return const Text('Active', style: TextStyle(fontSize: 10));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: totalPatients.toDouble(), color: Colors.blue)
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: totalDoctors.toDouble(), color: Colors.green)
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: totalPosts.toDouble(), color: Colors.orange)
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: totalBookings.toDouble(), color: Colors.purple)
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(toY: activeUsers.toDouble(), color: Colors.red)
          ]),
        ],
      ),
    ),
  );
}


  Widget analyticsRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
