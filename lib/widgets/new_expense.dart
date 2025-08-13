import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expoense_tracker/models/Expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final initialDate = DateTime.now();
    final firstDate = DateTime(
      initialDate.year - 1,
      initialDate.month,
      initialDate.day,
    );
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: initialDate,
      initialDate: initialDate,
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {

    final amountValue = double.tryParse(_amountController.text);
    final isAmountInvalid = amountValue == null || amountValue <= 0;

    if (isAmountInvalid ||
        _titleController.text.trim().isEmpty ||
        selectedDate == null) {

      _showDialog();

      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: amountValue,
        date: selectedDate!,
        category: _selectedCategory,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder:
            (ctx) => CupertinoAlertDialog(
              title: Text("Invalid input"),
              content: Text(
                "Please make sure you are entered valid title , amount , category and date !",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Okay"),
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text("Invalid input"),
              content: Text(
                "Please make sure you are entered valid title , amount , category and date !",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Okay"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(label: Text("Title")),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text("Amount"),
                        prefixText: "\$  ",
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedDate == null
                              ? "No date selected"
                              : formatter.format(selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items:
                        Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData,
                    child: Text("Save expense"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
