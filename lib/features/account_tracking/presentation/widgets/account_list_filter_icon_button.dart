import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:flutter/material.dart';

// TODO: onPress displays ModelDialog and display filtering options (status, type, etc)
class AccountPopupMenuButton extends StatefulWidget {
  final AccountNotifier notifier;
  const AccountPopupMenuButton({super.key, required this.notifier});

  @override
  State<AccountPopupMenuButton> createState() => _AccountPopupMenuButtonState();
}

class _AccountPopupMenuButtonState extends State<AccountPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(children: [Icon(Icons.filter_alt_sharp), Text("Filter")]),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  child: Center(child: Text('This is a Modal Bottom Sheet')),
                );
              },
            );
          },
        ),
        PopupMenuItem(
          child: const Text("Two"),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  child: Center(child: Text('This is a Modal Bottom Sheet')),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
