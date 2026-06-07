import 'package:ai_tracker/core/constants/account_status.dart';
import 'package:ai_tracker/features/account_tracking/presentation/notifiers/account_notifier.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/account_entity.dart';

class AccountCreatePage extends StatefulWidget {
  final AccountNotifier accountNotifier;
  const AccountCreatePage({super.key, required this.accountNotifier});

  @override
  State<StatefulWidget> createState() => _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );

    setState(() {
      _nextAvailableDate = pickedDate;
    });
  }

  // ? Create an State Map with on/off key
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
        final accountToSave = AccountEntity(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          description: _descriptionController.text.trim(),
          isActive: _isActive,
          status: _status,
          nextAvailableDate: _nextAvailableDate,
          createdDateTime: DateTime.now(),
        );

        await widget.accountNotifier.addAccount(accountToSave);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating account: ${e.toString()}')),
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
      appBar: AppBar(title: const Text("Create New Account")),
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
                spacing: 10,
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
                    : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
