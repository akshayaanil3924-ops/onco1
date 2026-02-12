class AppUser {
  final String name;
  final String userId;
  final String role;

  AppUser({
    required this.name,
    required this.userId,
    required this.role,
  });
}

class UserData {
  static List<AppUser> users = [
    AppUser(
      name: 'Ananya R.',
      userId: 'P1001',
      role: 'Patient',
    ),
    AppUser(
      name: 'Dr. Rahul Verma',
      userId: 'D2001',
      role: 'Doctor',
    ),
    AppUser(
      name: 'Nurse Meera',
      userId: 'M3001',
      role: 'Medical Staff',
    ),
  ];
}
