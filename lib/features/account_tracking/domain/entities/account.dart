import 'package:ai_tracker/core/constants/account_status.dart';

class Account {
  final int? id;
  final String name;
  final String description;
  final String email;
  final AccountStatus? status;
  final bool isActive;
  final DateTime? lastUsedDate;

  Account({
    this.id,
    required this.name,
    required this.description,
    required this.email,
    this.status,
    required this.isActive,
    this.lastUsedDate,
  });
}
