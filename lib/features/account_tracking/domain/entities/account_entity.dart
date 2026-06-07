import 'package:ai_tracker/core/constants/account_status.dart';

class AccountEntity {
  final int? id;
  final String name;
  final String description;
  final String email;
  final AccountStatus? status;
  final bool isActive;
  final DateTime? lastUsedDate;
  final DateTime? nextAvailableDate;
  final DateTime? createdDateTime;
  final DateTime? updatedDateTime;

  AccountEntity({
    this.id,
    required this.name,
    required this.description,
    required this.email,
    this.status,
    required this.isActive,
    this.lastUsedDate,
    this.nextAvailableDate,
    this.createdDateTime,
    this.updatedDateTime,
  });

  AccountEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? email,
    AccountStatus? status,
    bool? isActive,
    DateTime? lastUsedDate,
    DateTime? nextAvailableDate,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
      nextAvailableDate: nextAvailableDate ?? this.nextAvailableDate,
      createdDateTime: createdDateTime ?? this.createdDateTime,
      updatedDateTime: updatedDateTime ?? this.updatedDateTime,
    );
  }
}
