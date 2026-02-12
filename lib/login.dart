import 'package:flutter/material.dart';

import 'patient_dashboard.dart';
import 'doctor_dashboard.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _shakeAnimation;

  bool isLoading = false;
  bool obscurePassword = true;

  final Color deepBlue = const Color(0xFF0D47A1);

  // 🔐 DEFAULT ADMIN CREDENTIALS (SYSTEM SETUP)
  final String adminId = 'A1001';
  final String adminPassword = 'admin@123';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-0.03, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.03, 0), end: const Offset(0.03, 0)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.03, 0), end: Offset.zero),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  void showWelcome(String role) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome, $role 👋'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void handleLogin() async {
    String id = idController.text.trim();
    String password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      _controller.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ID and Password')),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => isLoading = false);
    id = id.toUpperCase();

    // ================= ADMIN LOGIN =================
    if (id == adminId && password == adminPassword) {
      showWelcome('Admin');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboard(role: 'admin'),
        ),
      );
      return;
    }

    // ================= MEDICAL STAFF LOGIN =================
    if (id.startsWith('M')) {
      showWelcome('Medical Staff');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboard(role: 'medical'),
        ),
      );
      return;
    }

    // ================= DOCTOR LOGIN =================
    if (id.startsWith('D')) {
      showWelcome('Doctor');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DoctorDashboard()),
      );
      return;
    }

    // ================= PATIENT LOGIN =================
    if (id.startsWith('P')) {
      showWelcome('Patient');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PatientDashboard()),
      );
      return;
    }

    // ================= INVALID =================
    _controller.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid ID or Password')),
    );
  }

  InputDecoration inputStyle(
      String label, IconData icon, Widget? suffix) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: deepBlue),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F8FF),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SlideTransition(
                position: _shakeAnimation,
                child: Card(
                  elevation: 10,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SizedBox(
                      width: 340,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade50,
                            ),
                            child: Icon(
                              Icons.volunteer_activism,
                              size: 60,
                              color: deepBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'OncoSoul',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: deepBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Care • Support • Hope',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: idController,
                            decoration: inputStyle(
                              'User ID',
                              Icons.person_outline,
                              null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            decoration: inputStyle(
                              'Password',
                              Icons.lock_outline,
                              IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please contact hospital administration',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: deepBlue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: deepBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: isLoading ? null : handleLogin,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
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
            ),
          ),
        ),
      ),
    );
  }
}
