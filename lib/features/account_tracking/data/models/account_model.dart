import 'package:ai_tracker/core/constants/account_status.dart';
import 'package:ai_tracker/features/account_tracking/domain/entities/account_entity.dart';

const String tableName = "tbl_accounts";

// Field Names
const String idField = "_id";
const String nameField = "name";
const String descriptionField = "description";
const String emailField = "email";
const String statusField = "status";
const String isActiveField = "is_active";
const String lastUsedDateField = "last_used_date";
const String nextAvailableDateField = "next_available_date";
const String createdDateTimeField = "created_date_time";
const String updatedDateTimeField = "updated_date_time";

// Field Data Types
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textType = "TEXT";
const String textTypeUnique = "TEXT UNIQUE";
const String intTypeNotNullDefaultZero = "INT NOT NULL DEFAULT 0";

class AccountModel extends AccountEntity {
  AccountModel({
    super.id,
    required super.name,
    required super.description,
    required super.email,
    super.status,
    required super.isActive,
    super.lastUsedDate,
    super.nextAvailableDate,
    super.createdDateTime,
    super.updatedDateTime,
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
      nextAvailableDate: json[nextAvailableDateField] != null
          ? DateTime.parse(json[nextAvailableDateField] as String)
          : null,
      createdDateTime: json[createdDateTimeField] != null
          ? DateTime.parse(json[createdDateTimeField] as String)
          : null,
      updatedDateTime: json[updatedDateTimeField] != null
          ? DateTime.parse(json[updatedDateTimeField] as String)
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
      nextAvailableDateField: nextAvailableDate?.toIso8601String(),
      createdDateTimeField: createdDateTime?.toIso8601String(),
      updatedDateTimeField: updatedDateTime?.toIso8601String(),
    };
  }

  @override
  AccountModel copyWith({
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
    return AccountModel(
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

  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      email: entity.email,
      status: entity.status,
      isActive: entity.isActive,
      lastUsedDate: entity.lastUsedDate,
      nextAvailableDate: entity.nextAvailableDate,
      createdDateTime: entity.createdDateTime,
      updatedDateTime: entity.updatedDateTime,
    );
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      name: name,
      description: description,
      email: email,
      status: status,
      isActive: isActive,
      lastUsedDate: lastUsedDate,
      nextAvailableDate: nextAvailableDate,
      createdDateTime: createdDateTime,
      updatedDateTime: updatedDateTime,
    );
  }
}
