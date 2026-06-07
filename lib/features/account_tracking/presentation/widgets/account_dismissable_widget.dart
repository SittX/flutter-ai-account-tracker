import 'package:ai_tracker/core/constants/account_status.dart';
import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account_entity.dart';
import '../pages/account_details_page.dart';

class AccountDismissableWidget extends StatefulWidget {
  final AccountNotifier notifier;
  final AccountEntity account;

  const AccountDismissableWidget({
    super.key,
    required this.notifier,
    required this.account,
  });

  @override
  State<AccountDismissableWidget> createState() =>
      _AccountDismissableWidgetState();
}

class _AccountDismissableWidgetState extends State<AccountDismissableWidget> {
  Future<bool> _handleDismiss(
    DismissDirection direction,
    AccountEntity data,
  ) async {
    if (direction == DismissDirection.startToEnd) {
      await widget.notifier.updateAccountStatus(
        data.id!,
        AccountStatus.available,
      );

      return false;
    } else {
      await widget.notifier.updateAccountStatus(
        data.id!,
        AccountStatus.limitHit,
      );

      return false;
    }
  }

  Widget _accountTile(BuildContext context, AccountEntity data) {
    final isAccountAvailable = data.status == AccountStatus.available;

    return ListTile(
      textColor: isAccountAvailable ? Colors.white : Colors.white38,
      title: Text(data.name),
      subtitle: Text(
        data.email,
        style: TextStyle(
          color: isAccountAvailable ? Colors.white70 : Colors.white38,
          fontStyle: FontStyle.italic,
        ),
      ),
      contentPadding: EdgeInsets.all(10),
      trailing: isAccountAvailable
          ? Icon(Icons.check_circle_rounded, color: Colors.green)
          : Icon(Icons.not_interested_rounded, color: Colors.red),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountDetailsPage(
              account: data,
              accountNotifier: widget.notifier,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.account;
    return Dismissible(
      key: Key("${data.id}_${data.status}"),
      background: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10.0,
            children: [
              Icon(Icons.check),
              Text("Available", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10.0,
            children: [
              Text("Limit Hit", style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.disabled_by_default),
            ],
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) =>
          _handleDismiss(direction, data),
      child: _accountTile(context, data),
    );
  }
}
