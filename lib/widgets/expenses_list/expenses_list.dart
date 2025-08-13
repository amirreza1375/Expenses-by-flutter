 import 'package:expoense_tracker/models/Expense.dart';
import 'package:expoense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final void Function(Expense expense) onRemoveExpense;

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder:
          (ctx, index) => Dismissible(
            background: Container(color: Theme.of(context).colorScheme.error.withOpacity(0.75),margin: EdgeInsets.symmetric(horizontal: 16),),
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            key: ValueKey(expenses[index].id),
            child: ExpenseItem(expenses[index]),
          ),
    );
  }
}
