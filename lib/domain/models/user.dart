enum UserRole { doctor, assister, receptionist }

class User {
  final String id;
  final String name;
  final UserRole role;
  final List<String> permissions;

  User({required this.id, required this.name, required this.role, required this.permissions});
}