import 'package:flutter/material.dart';
import 'doctor/appointments_screen.dart';
import 'doctor/consultations_page.dart';
import 'doctor/patients_page.dart';
import 'doctor/medical_report_page.dart';
import 'models/report_model.dart';
import 'models/patient_model.dart';
import 'login.dart';
import 'services/notification_service.dart';
import 'widgets/notification_panel.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
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
    _notifService.markAllDoctorRead();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(ctx).padding.top + kToolbarHeight + 4,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: ListenableBuilder(
                  listenable: _notifService,
                  builder: (_, __) => NotificationPanel(
                    notifications: _notifService.doctorNotifications,
                    onMarkAllRead: _notifService.markAllDoctorRead,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color deepBlue = const Color(0xFF0D47A1);
    final Color accentBlue = const Color(0xFF2E7DFF);
    final unreadCount = _notifService.doctorUnreadCount;

    final List<ReportModel> johnReports = [
      ReportModel(title: "Blood Test Report", date: "2025-02-10", path: ""),
      ReportModel(title: "X-Ray Report", date: "2025-02-08", path: ""),
    ];
    final List<ReportModel> sarahReports = [
      ReportModel(title: "CT Scan Report", date: "2025-02-05", path: ""),
    ];
    final List<PatientModel> patients = [
      PatientModel(id: "P001", name: "John Doe", reports: johnReports),
      PatientModel(id: "P002", name: "Sarah Smith", reports: sarahReports),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_hospital, color: accentBlue),
            const SizedBox(width: 6),
            Text(
              'Doctor Dashboard',
              style: TextStyle(color: deepBlue, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          // 🔔 Notification Bell
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none, color: Colors.black87),
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
              onPressed: () => _showNotificationPanel(context),
            ),
          ),
          // 🚪 Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
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
            _optionBox(context, icon: Icons.video_call_outlined, title: 'Online Consultation', subtitle: 'Consult patients online', color: Colors.blue.shade700, screen: ConsultationsPage()),
            _optionBox(context, icon: Icons.description_outlined, title: 'View Reports', subtitle: 'Access medical reports', color: Colors.teal.shade700, screen: MedicalReportsPage(patients: patients)),
            _optionBox(context, icon: Icons.people_outline, title: 'My Patients', subtitle: 'View patient list', color: Colors.purple.shade700, screen: PatientsPage()),
            _optionBox(context, icon: Icons.event_available_outlined, title: 'Appointments', subtitle: 'Manage appointments', color: Colors.green.shade700, screen: AppointmentsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _optionBox(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required Widget screen}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.20)),
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}