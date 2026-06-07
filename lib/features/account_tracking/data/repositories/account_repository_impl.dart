import 'package:ai_tracker/core/constants/account_status.dart';
import 'package:ai_tracker/features/account_tracking/data/datasources/account_local_data_source.dart';
import 'package:ai_tracker/features/account_tracking/data/models/account_model.dart';
import 'package:ai_tracker/features/account_tracking/domain/entities/account_entity.dart';
import 'package:ai_tracker/features/account_tracking/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountLocalDataSource accountLocalDateSource;

  AccountRepositoryImpl({required this.accountLocalDateSource});

  @override
  Future<AccountEntity> createNewAccount(AccountEntity account) async {
    final AccountModel createPayload = AccountModel(
      id: account.id,
      name: account.name,
      description: account.description,
      email: account.email,
      status: account.status,
      isActive: account.isActive,
      lastUsedDate: account.lastUsedDate,
      nextAvailableDate: account.nextAvailableDate,
      createdDateTime: account.createdDateTime,
      updatedDateTime: account.updatedDateTime,
    );

    final AccountModel createdModel = await accountLocalDateSource
        .createNewAccount(createPayload);

    return createdModel.toEntity();
  }

  @override
  Future<AccountEntity> getAccountById(int id) async {
    final futureAccount = await accountLocalDateSource.fetchById(id);
    return futureAccount.toEntity();
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final accountList = await accountLocalDateSource.fetchAll();

    return accountList
        .map((account) => account.toEntity())
        .toList(growable: false);
  }

  @override
  Future<AccountEntity> updateAccountInactive(int id) {
    throw UnimplementedError();
  }

  @override
  Future<AccountEntity> updateExistingAccount(
    int id,
    AccountEntity account,
  ) async {
    final AccountModel updatePayload = AccountModel(
      id: account.id,
      name: account.name,
      description: account.description,
      email: account.email,
      status: account.status,
      isActive: account.isActive,
      lastUsedDate: account.lastUsedDate,
      nextAvailableDate: account.nextAvailableDate,
      updatedDateTime: account.updatedDateTime,
    );

    final AccountModel updatedModel = await accountLocalDateSource
        .updateExistingAccount(id, updatePayload);

    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteAccount(int id) async {
    await accountLocalDateSource.deleteAccount(id);
  }

  @override
  Future<void> updateAccountStatus(int id, AccountStatus status) async {
    await accountLocalDateSource.updateAccountStatus(id, status);
  }
}
