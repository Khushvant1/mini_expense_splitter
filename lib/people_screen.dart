import 'package:flutter/material.dart';
import 'package:mini_expense_splitter/expense_screen.dart';

import 'model/expense_model.dart';
import 'model/person.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final people = <Person>[];
  final expenses = <ExpenseModel>[];
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Add People",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          textInputField(),
          peopleList(),
          buildAddExpenseButton(context),
        ],
      ),
    );
  }

  /// text input field or add button here
  Widget textInputField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Enter Name",
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.person, color: Colors.grey.shade500),
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
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    people.add(Person(name: nameController.text.trim()));
                    nameController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// list of add people
  Widget peopleList() {
    return Expanded(
      child: people.isEmpty
          ? const Center(
        child: Text(
          "No people added yet",
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      )
          : ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              color: Colors.blue.shade800.withAlpha(20),
              margin: const EdgeInsets.all(4.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    people[index].name[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  people[index].name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            );
          }),
    );
  }

  /// add expense button
  Widget buildAddExpenseButton(BuildContext context) {
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
          onPressed: people.isEmpty
              ? null
              : () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExpenseScreen(
                      people: people,
                      expenses: expenses,
                    )));
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
}
