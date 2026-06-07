import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:ai_tracker/features/account_tracking/presentation/pages/account_list_search_page.dart';
import 'package:flutter/material.dart';

class AccountListSearchIconButton extends StatefulWidget {
  final AccountNotifier notifier;
  const AccountListSearchIconButton({super.key, required this.notifier});

  @override
  State<AccountListSearchIconButton> createState() =>
      _AccountListSearchIconButtonState();
}

class _AccountListSearchIconButtonState
    extends State<AccountListSearchIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                AccountListSearchPage(notifier: widget.notifier),
          ),
        );
      },
      icon: Icon(Icons.search),
    );
  }
}
