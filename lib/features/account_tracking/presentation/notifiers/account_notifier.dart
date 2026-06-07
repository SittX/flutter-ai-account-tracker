import 'package:ai_tracker/features/account_tracking/domain/entities/account_entity.dart';
import 'package:ai_tracker/features/account_tracking/domain/repositories/account_repository.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/account_status.dart';

class AccountNotifier extends ChangeNotifier {
  final AccountRepository _repository;

  AccountNotifier({required this._repository});

  List<AccountEntity> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AccountEntity> get accounts => _accounts;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_accounts.isNotEmpty) return;

    try {
      List<AccountEntity> fetchAccounts = await _repository.getAccounts();
      _accounts = [..._accounts, ...fetchAccounts];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addAccount(AccountEntity account) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newAccount = await _repository.createNewAccount(account);
      _accounts = [..._accounts, newAccount];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAccount(int id, AccountEntity account) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedAccount = await _repository.updateExistingAccount(
        id,
        account,
      );
      final index = _accounts.indexWhere((a) => a.id == id);
      if (index != -1) {
        _accounts[index] = updatedAccount;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAccountStatus(int id, AccountStatus status) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateAccountStatus(id, status);
      _accounts = _accounts.map((account) {
        if (account.id == id) {
          return account.copyWith(status: status);
        }
        return account;
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteAccount(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteAccount(id);
      _accounts = _accounts.where((account) => account.id != id).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
