import 'package:ai_tracker/features/account_tracking/domain/entities/account.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts();
  Future<Account> getAccountById(int id);
  Future<Account> createNewAccount(Account account);
  Future<void> deleteAccount(int id);
  Future<Account> updateExistingAccount(int id, Account account);
  Future<Account> updateAccountInactive(int id);
}
