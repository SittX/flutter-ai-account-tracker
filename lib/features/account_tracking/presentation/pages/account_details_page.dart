import 'package:flutter/material.dart';

import '../../../../core/constants/account_status.dart';
import '../../domain/entities/account_entity.dart';
import '../notifiers/account_notifier.dart';

class AccountDetailsPage extends StatefulWidget {
  final AccountEntity account;
  final AccountNotifier accountNotifier;
  const AccountDetailsPage({
    super.key,
    required this.account,
    required this.accountNotifier,
  });

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // ? Form States
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isActive = true;
  AccountStatus _status = AccountStatus.available;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.name;
    _descriptionController.text = widget.account.description;
    _emailController.text = widget.account.email;
    _isActive = widget.account.isActive;
    _status = widget.account.status ?? AccountStatus.available;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  static const WidgetStateProperty<Icon> activeIcon =
      WidgetStateProperty.fromMap({
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  Future<void> _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final accountToUpdate = AccountEntity(
          id: widget.account.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          description: _descriptionController.text.trim(),
          isActive: _isActive,
          status: _status,
          updatedDateTime: DateTime.now(),
        );

        if (widget.account.id != null) {
          await widget.accountNotifier.updateAccount(
            widget.account.id!,
            accountToUpdate,
          );
        } else {
          await widget.accountNotifier.addAccount(accountToUpdate);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account updated successfully!')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating account: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showDeleteConfirmDialog(int id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Account?"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => widget.accountNotifier.deleteAccount(id),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15.0,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(
                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: AccountStatus.values.map((s) {
                  return ChoiceChip(
                    label: Text(s.value),
                    selected: _status == s,
                    onSelected: (bool selected) {
                      setState(() {
                        _status = s;
                      });
                    },
                  );
                }).toList(),
              ),
              Row(
                spacing: 10.0,
                children: [
                  const Text("Active", style: TextStyle(fontSize: 16)),
                  Switch(
                    thumbIcon: activeIcon,
                    value: _isActive,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isActive = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAccount,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Update"),
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        _showDeleteConfirmDialog(widget.account.id!);
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.red,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: .center,
                        spacing: 10,
                        children: [Text("Delete"), Icon(Icons.delete)],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
