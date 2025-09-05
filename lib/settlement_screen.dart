import 'package:flutter/material.dart';
import 'package:mini_expense_splitter/service/expense_splitter.dart';

import 'model/expense_model.dart';
import 'model/person.dart';

class SettlementScreen extends StatefulWidget {
  final List<Person> people;
  final List<ExpenseModel> expenses;

  const SettlementScreen({super.key, required this.people, required this.expenses,});

  @override
  State<SettlementScreen> createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  @override
  Widget build(BuildContext context) {

    final splitter = ExpenseSplitter(widget.people, widget.expenses);
    final transactions = splitter.minimumCashFlow();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          "Final Settlement",
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          // transaction
          ...transactions.isEmpty
              ? [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Everything is settled!',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            )
          ]
              : transactions
              .map((transaction) => Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                  '${transaction.from.name} pays ${transaction.to.name} ₹${transaction.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )
              ),
            ),
          ))
              .toList(),

          // ---- Expenses Section (showing description) ----
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              'All Expenses:',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
            ),
          ),
          ...widget.expenses.map((e) => Card(
            color: Colors.grey.shade50,
            child: ListTile(
              title: Text('${e.payer.name} paid ₹${e.amount.toStringAsFixed(2)}', style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )),
              subtitle: (e.description != null && e.description!.trim().isNotEmpty)
                  ? Text('Description: ${e.description}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  )
              )
                  : Text('No Description'),
            ),
          )),
        ],
      ),
    );
  }
}
