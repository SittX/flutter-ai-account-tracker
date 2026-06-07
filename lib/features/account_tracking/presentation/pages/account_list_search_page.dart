import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:flutter/material.dart';

import 'account_details_page.dart';

class AccountListSearchPage extends StatefulWidget {
  final AccountNotifier notifier;
  const AccountListSearchPage({super.key, required this.notifier});

  @override
  State<AccountListSearchPage> createState() => _AccountListSearchPageState();
}

class _AccountListSearchPageState extends State<AccountListSearchPage> {
  final _searchInputController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchInputController.addListener(() {
      setState(() {
        _searchQuery = _searchInputController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Account")),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchInputController,
              decoration: const InputDecoration(
                hintText: "Search by name or email...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
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

                final accounts = widget.notifier.accounts.where((account) {
                  return account.name.toLowerCase().contains(_searchQuery) ||
                      account.email.toLowerCase().contains(_searchQuery);
                }).toList();

                if (accounts.isEmpty) {
                  return const Center(
                    child: Text('No accounts found matching search.'),
                  );
                }

                return ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final data = accounts[index];
                    return ListTile(
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
                      title: Text(data.name),
                      subtitle: Text(data.email),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
