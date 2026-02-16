import 'package:flutter/material.dart';
import 'login.dart';

// Admin screens
import 'screens/admin_manage_appointments_screen.dart';
import 'screens/admin_user_account_screen.dart';
import 'screens/admin_reset_password_screen.dart';
import 'screens/admin_homestay_management_screen.dart';
import 'screens/admin_awareness_management_screen.dart';
import 'screens/admin_community_moderation_screen.dart';
import 'screens/admin_user_list_screen.dart'; // ✅ NEW

// Medical staff screens
import 'screens/upload_medical_report_screen.dart';
import 'screens/medical_staff_view_appointments_screen.dart';

class AdminDashboard extends StatelessWidget {
  final String role; // 'admin' or 'medical'

  const AdminDashboard({super.key, required this.role});

  final Color deepBlue = const Color(0xFF0D47A1);
  final Color accentBlue = const Color.fromARGB(255, 70, 100, 150);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        // ================= APP BAR (UNCHANGED) =================
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: deepBlue,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),

        // ================= BODY =================
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role == 'admin' ? 'Administration' : 'Medical Staff',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: deepBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                role == 'admin'
                    ? 'Manage hospital system & users'
                    : 'Manage reports and appointments',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: [

                    // ================= MEDICAL STAFF OPTIONS =================
                    if (role == 'medical') ...[
                      optionBox(
                        context,
                        icon: Icons.upload_file_outlined,
                        title: 'Upload Medical Reports',
                        subtitle: 'Lab reports & diagnostics',
                        titleColor: const Color(0xFF4A148C),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const UploadMedicalReportScreen(),
                            ),
                          );
                        },
                      ),
                      optionBox(
                        context,
                        icon: Icons.event_note_outlined,
                        title: 'Appointments',
                        subtitle: 'Confirmed patient appointments',
                        titleColor: const Color(0xFF3E2723),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MedicalStaffViewAppointmentsScreen(),
                            ),
                          );
                        },
                      ),
                    ],

                    // ================= ADMIN OPTIONS =================
                    if (role == 'admin') ...[

                      optionBox(
                        context,
                        icon: Icons.person_add_outlined,
                        title: 'User Accounts',
                        subtitle: 'Add patients & medical staff',
                        titleColor: const Color(0xFF263238),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminUserAccountScreen(),
                            ),
                          );
                        },
                      ),

                      // ✅ NEW USER LIST OPTION
                      optionBox(
                        context,
                        icon: Icons.people_outline,
                        title: 'User List',
                        subtitle: 'View all registered users',
                        titleColor: const Color(0xFF1B5E20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminUserListScreen(),
                            ),
                          );
                        },
                      ),

                      optionBox(
                        context,
                        icon: Icons.lock_reset_outlined,
                        title: 'Reset Password',
                        subtitle: 'Regenerate user credentials',
                        titleColor: const Color(0xFF455A64),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminResetPasswordScreen(),
                            ),
                          );
                        },
                      ),

                      optionBox(
                        context,
                        icon: Icons.event_available_outlined,
                        title: 'Appointments',
                        subtitle: 'Rules & confirmed bookings',
                        titleColor: const Color(0xFF3E2723),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminManageAppointmentsScreen(),
                            ),
                          );
                        },
                      ),

                      optionBox(
                        context,
                        icon: Icons.home_work_outlined,
                        title: 'Accomodation Details',
                        subtitle: 'Accommodation support',
                        titleColor: const Color(0xFF0D47A1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminHomestayManagementScreen(),
                            ),
                          );
                        },
                      ),

                      optionBox(
                        context,
                        icon: Icons.forum_outlined,
                        title: 'Community Moderation',
                        subtitle: 'Monitor patient discussions',
                        titleColor: const Color(0xFF37474F),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminCommunityModerationScreen(),
                            ),
                          );
                        },
                      ),

                      optionBox(
                        context,
                        icon: Icons.campaign_outlined,
                        title: 'Awareness Content',
                        subtitle: 'Education & information',
                        titleColor: const Color(0xFF5D4037),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AdminAwarenessManagementScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= OPTION BOX =================
  Widget optionBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color titleColor,
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
            border: Border.all(color: Colors.white),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: titleColor.withValues(alpha: 0.15),
                child: Icon(icon, color: titleColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
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
                color: titleColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
