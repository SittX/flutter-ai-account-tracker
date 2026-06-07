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
  DateTime? _nextAvailableDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.name;
    _descriptionController.text = widget.account.description;
    _emailController.text = widget.account.email;
    _isActive = widget.account.isActive;
    _status = widget.account.status ?? AccountStatus.available;
    _nextAvailableDate = widget.account.nextAvailableDate;
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

  Future<void> _updateAccount() async {
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
          nextAvailableDate: _nextAvailableDate,
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

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _nextAvailableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );

    setState(() {
      _nextAvailableDate = pickedDate;
    });
  }

  void _showDeleteConfirmDialog(int id) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text(
          "Are you sure you want to delete this account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.accountNotifier.deleteAccount(id);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully!')),
        );

        // Pop back to the list page
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: ${e.toString()}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 30.0,
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

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
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
                ],
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  if (_nextAvailableDate != null)
                    Text(
                      "Next Available Date: ${_nextAvailableDate?.toIso8601String().split("T")[0]}",
                    ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Text("Next Available Date"),
                          Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateAccount,
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
