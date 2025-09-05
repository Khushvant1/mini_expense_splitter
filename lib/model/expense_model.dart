import 'package:mini_expense_splitter/model/person.dart';

class ExpenseModel{
  final Person payer;
  final double amount;
  final String? description;
  final String? imagePath;

  ExpenseModel({
    required this.payer,
    required this.amount,
    this.description,
    this.imagePath,
  });

}