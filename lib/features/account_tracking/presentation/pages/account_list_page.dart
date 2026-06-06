import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:ai_tracker/features/account_tracking/presentation/pages/account_details_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account.dart';
import 'account_create_page.dart';

class AccountListPage extends StatefulWidget {
  final AccountNotifier notifier;
  const AccountListPage({super.key, required this.notifier});

  @override
  State<StatefulWidget> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  @override
  void initState() {
    super.initState();
    widget.notifier.loadAccounts();
  }

  Future<bool> showDeleteConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Account Delete?"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }

  Widget accountTile(BuildContext context, Account data) {
    return ListTile(
      title: Text(data.name),
      subtitle: Text(data.email),
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

  Future<bool?> onConfirmDismiss(DismissDirection direction) async {
    if (direction == DismissDirection.startToEnd) {
      return false;
    } else {
      return await showDeleteConfirmDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListenableBuilder(
        listenable: widget.notifier,
        builder: (context, child) {
          if (widget.notifier.isLoading && widget.notifier.accounts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.notifier.errorMessage != null) {
            return Center(
              child: Text('Error: ${widget.notifier.errorMessage}'),
            );
          }

          final accounts = widget.notifier.accounts;

          if (accounts.isEmpty) {
            return const Center(child: Text('No accounts found. Add one!'));
          }

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final data = accounts[index];

              return Dismissible(
                key: Key(data.id!.toString()),
                background: Container(color: Colors.green),
                secondaryBackground: Container(color: Colors.red),
                confirmDismiss: onConfirmDismiss,
                onDismissed: (DismissDirection direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await widget.notifier.deleteAccount(data.id!);
                  }
                },
                child: accountTile(context, data),
              );
            },
          );
        },
      ),
    );
  }
}
