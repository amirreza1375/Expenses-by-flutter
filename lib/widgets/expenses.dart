import 'package:expoense_tracker/main.dart';
import 'package:expoense_tracker/widgets/chart/chart.dart';
import 'package:expoense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expoense_tracker/models/Expense.dart';
import 'package:expoense_tracker/widgets/new_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> expenses = [
    Expense(
      title: "asd",
      amount: 12,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: "asd",
      amount: 12,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void onAddNewExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
    Navigator.pop(context);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: onAddNewExpense),
    );
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = expenses.indexOf(expense);
    setState(() {
      expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              expenses.insert(expenseIndex, expense);
            });
          },
        ),
        content: Text("${expense.title} deleted ! "),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text("No expenses found , Start adding some !"),
    );
    if (!expenses.isEmpty) {
      mainContent = ExpensesList(
        expenses: expenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body:
          width < 600
              ? Column(
                children: [
                  Chart(expenses: expenses),
                  Expanded(child: mainContent),
                ],
              )
              : Row(
                children: [
                  Expanded(child: Chart(expenses: expenses)),
                  Expanded(child: mainContent),
                ],
              ),
    );
  }
}
