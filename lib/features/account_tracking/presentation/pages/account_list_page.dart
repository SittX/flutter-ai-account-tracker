import 'package:ai_tracker/core/constants/account_status.dart';
import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:ai_tracker/features/account_tracking/presentation/widgets/account_dismissable_widget.dart';
import 'package:ai_tracker/features/account_tracking/presentation/widgets/account_list_search_icon_button.dart';
import 'package:flutter/material.dart';

import 'account_create_page.dart';

class AccountListPage extends StatefulWidget {
  final AccountNotifier notifier;
  const AccountListPage({super.key, required this.notifier});

  @override
  State<StatefulWidget> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  AccountStatus? _selectedAccountStatus;

  @override
  void initState() {
    super.initState();
    widget.notifier.loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Accounts",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: [AccountListSearchIconButton(notifier: widget.notifier)],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AccountCreatePage(accountNotifier: widget.notifier),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 15,
              children: AccountStatus.values.map((s) {
                return ChoiceChip(
                  label: Text(s.value),
                  selected: _selectedAccountStatus == s,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedAccountStatus = _selectedAccountStatus == s
                          ? null
                          : s;
                    });
                  },
                );
              }).toList(),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.notifier,
                builder: (context, child) {
                  if (widget.notifier.isLoading &&
                      widget.notifier.accounts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (widget.notifier.errorMessage != null) {
                    return Center(
                      child: Text('Error: ${widget.notifier.errorMessage}'),
                    );
                  }

                  final accounts = widget.notifier.accounts
                      .where(
                        (a) =>
                            _selectedAccountStatus == null ||
                            a.status == _selectedAccountStatus,
                      )
                      .toList();

                  if (accounts.isEmpty) {
                    return const Center(
                      child: Text('No accounts found. Add one!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final data = accounts[index];
                      return AccountDismissableWidget(
                        notifier: widget.notifier,
                        account: data,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
