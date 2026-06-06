import 'package:ai_tracker/features/account_tracking/data/datasources/account_local_data_source.dart';
import 'package:ai_tracker/features/account_tracking/data/models/account_model.dart';
import 'package:ai_tracker/features/account_tracking/domain/entities/account.dart';
import 'package:ai_tracker/features/account_tracking/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountLocalDataSource accountLocalDateSource;

  AccountRepositoryImpl({required this.accountLocalDateSource});

  @override
  Future<Account> createNewAccount(Account account) async {
    final AccountModel createPayload = AccountModel(
      id: account.id,
      name: account.name,
      description: account.description,
      email: account.email,
      status: account.status,
      isActive: account.isActive,
      lastUsedDate: account.lastUsedDate,
    );

    final AccountModel createdModel = await accountLocalDateSource
        .createNewAccount(createPayload);

    return createdModel.toEntity();
  }

  @override
  Future<Account> getAccountById(int id) async {
    final futureAccount = await accountLocalDateSource.fetchById(id);
    return futureAccount.toEntity();
  }

  @override
  Future<List<Account>> getAccounts() async {
    final accountList = await accountLocalDateSource.fetchAll();

    return accountList
        .map((account) => account.toEntity())
        .toList(growable: false);
  }

  @override
  Future<Account> updateAccountInactive(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Account> updateExistingAccount(int id, Account account) async {
    final AccountModel updatePayload = AccountModel(
      id: account.id,
      name: account.name,
      description: account.description,
      email: account.email,
      status: account.status,
      isActive: account.isActive,
      lastUsedDate: account.lastUsedDate,
    );

    final AccountModel updatedModel = await accountLocalDateSource
        .updateExistingAccount(id, updatePayload);

    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteAccount(int id) async {
    await accountLocalDateSource.deleteAccount(id);
  }
}
