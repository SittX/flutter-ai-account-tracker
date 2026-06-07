import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:flutter/material.dart';

// TODO: onPress displays ModelDialog and display filtering options (status, type, etc)
class AccountListFilterIconButton extends StatefulWidget {
  final AccountNotifier notifier;
  const AccountListFilterIconButton({super.key, required this.notifier});

  @override
  State<AccountListFilterIconButton> createState() =>
      _AccountListFilterIconButtonState();
}

class _AccountListFilterIconButtonState
    extends State<AccountListFilterIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_sharp));
  }
}
