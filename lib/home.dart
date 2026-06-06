import 'package:ai_tracker/features/account_tracking/data/datasources/account_local_data_source.dart';
import 'package:ai_tracker/features/account_tracking/data/repositories/account_repository_impl.dart';
import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:ai_tracker/features/account_tracking/presentation/pages/account_dashboard_page.dart';
import 'package:ai_tracker/features/account_tracking/presentation/pages/account_list_page.dart';
import 'package:ai_tracker/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = 0;
  var pages = [
    DashboardPage(),
    AccountListPage(
      notifier: AccountNotifier(
        repository: AccountRepositoryImpl(
          accountLocalDateSource: AccountLocalDataSource(),
        ),
      ),
    ),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.account_box),
            label: "Accounts",
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        selectedIndex: currentPage,
        onDestinationSelected: (value) {
          setState(() {
            currentPage = value;
          });
        },
      ),
    );
  }
}
