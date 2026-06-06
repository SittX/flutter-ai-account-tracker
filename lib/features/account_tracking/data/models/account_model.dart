import 'package:ai_tracker/core/constants/account_status.dart';
import 'package:ai_tracker/features/account_tracking/domain/entities/account.dart';

const String tableName = "tbl_accounts";

// Field Names
const String idField = "_id";
const String nameField = "name";
const String descriptionField = "description";
const String emailField = "email";
const String statusField = "status";
const String isActiveField = "is_active";
const String lastUsedDateField = "last_used_date";

// Field Data Types
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textType = "TEXT";
const String textTypeUnique = "TEXT UNIQUE";
const String intTypeNotNullDefaultZero = "INT NOT NULL DEFAULT 0";

class AccountModel extends Account {
  AccountModel({
    super.id,
    required super.name,
    required super.description,
    required super.email,
    super.status,
    required super.isActive,
    super.lastUsedDate,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json[idField] as int?,
      name: json[nameField] as String,
      description: json[descriptionField] as String,
      email: json[emailField] as String,
      isActive: (json[isActiveField] as int) == 1,
      status: json[statusField] != null
          ? AccountStatus.values.byName(json[statusField] as String)
          : null,
      lastUsedDate: json[lastUsedDateField] != null
          ? DateTime.parse(json[lastUsedDateField] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) idField: id,
      nameField: name,
      descriptionField: description,
      emailField: email,
      isActiveField: isActive ? 1 : 0,
      statusField: status?.name,
      lastUsedDateField: lastUsedDate?.toIso8601String(),
    };
  }

  AccountModel copyWith({
    int? id,
    String? name,
    String? description,
    String? email,
    AccountStatus? status,
    bool? isActive,
    DateTime? lastUsedDate,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
    );
  }

  Account toEntity() {
    return Account(
      id: id,
      name: name,
      description: description,
      email: email,
      status: status,
      isActive: isActive,
      lastUsedDate: lastUsedDate,
    );
  }
}
