import 'package:flutter/material.dart';
import 'package:mini_expense_splitter/settlement_screen.dart';

import 'model/expense_model.dart';
import 'model/person.dart';

class ExpenseScreen extends StatefulWidget {
  final List<Person> people;
  final List<ExpenseModel> expenses;

  const ExpenseScreen({super.key, required this.people, required this.expenses,});
  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}
class _ExpenseScreenState extends State<ExpenseScreen> {
  Person? selectPayer;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Add Expense",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          payerDropdown(),
          amountField(),
          descriptionField(),
          addExpenseButton(),
          expenseList(),
          settleUpButton(context),
        ],
      ),
    );
  }

  /// dropdown to the select payer
  Widget payerDropdown() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade800.withAlpha(20),
      ),
      child: DropdownButton<Person>(
        isExpanded: true,
        value: selectPayer,
        elevation: 1,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
        style: const TextStyle(fontSize: 15, color: Colors.black),
        hint: Text(
          "Select Payer",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
        underline: Container(),
        items: widget.people
            .map((p) => DropdownMenuItem(
          value: p,
          child: Text(
            p.name,
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectPayer = value;
          });
        },
      ),
    );
  }

  /// amount input field
  Widget amountField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: amountController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Enter Amount",
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(Icons.attach_money, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.blue.shade800,
              width: 1.5,
            ),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget descriptionField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: descController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Description (Optional)",
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(Icons.description_outlined, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.blue.shade800,
              width: 1.4,
            ),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  /// add Expense Button
  Widget addExpenseButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            final payer = selectPayer;
            final amt = double.tryParse(amountController.text) ?? 0.0;
            if (payer != null && amt > 0) {
              setState(() {
                widget.expenses.add(
                  ExpenseModel(
                    payer: payer,
                    amount: amt,
                    description:
                    descController.text.isEmpty ? null : descController.text,
                  ),
                );
                // clear
                amountController.clear();
                descController.clear();
                selectPayer = null;
              });
            }
          },
          icon: const Icon(Icons.attach_money, size: 20),
          label: const Text(
            "Add Expense",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  ///list of added expenses
  Widget expenseList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.expenses.length,
        itemBuilder: (context, index) {
          final expense = widget.expenses[index];
          return Card(
            elevation: 0,
            color: Colors.blue.shade800.withAlpha(20),
            child: ListTile(
              title: Text(
                '${expense.payer.name} paid Rs ${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: expense.description != null
                ? Text(expense.description ?? "",  style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),)
                  : null
            ),
          );
        },
      ),
    );
  }

  /// settle button
  Widget settleUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: widget.expenses.isEmpty
              ? null
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettlementScreen(
                  people: widget.people,
                  expenses: widget.expenses,
                ),
              ),
            );
          },
          label: const Text(
            "Settle Up",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
