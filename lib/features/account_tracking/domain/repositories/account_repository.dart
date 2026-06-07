import 'package:ai_tracker/features/account_tracking/domain/entities/account_entity.dart';

import '../../../../core/constants/account_status.dart';

abstract class AccountRepository {
  Future<List<AccountEntity>> getAccounts();
  Future<AccountEntity> getAccountById(int id);
  Future<AccountEntity> createNewAccount(AccountEntity account);
  Future<void> deleteAccount(int id);
  Future<AccountEntity> updateExistingAccount(int id, AccountEntity account);
  Future<AccountEntity> updateAccountInactive(int id);
  Future<void> updateAccountStatus(int id, AccountStatus status);
}
