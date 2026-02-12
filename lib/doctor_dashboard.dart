import 'package:flutter/material.dart';
import 'login.dart';

class DoctorDashboard extends StatelessWidget {
   const DoctorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.medical_services,
                  size: 60,
                  color: Colors.green,
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome Doctor',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
