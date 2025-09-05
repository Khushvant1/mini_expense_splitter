import '../model/expense_model.dart';
import '../model/person.dart';

class Transaction {
  final Person from;
  final Person to;
  final double amount;
  Transaction(this.from, this.to, this.amount);
}

class ExpenseSplitter {
  final List<Person> people;
  final List<ExpenseModel> expenses;
  ExpenseSplitter(this.people, this.expenses);

  /// calculate the net balance function
  Map<Person, double> calculateNetBalances() {
    final net = {
      for (var p in people)
        p: 0.0
    };
    double total = 0.0;
    for (var e in expenses) {
      total += e.amount;
      net[e.payer] = net[e.payer]! + e.amount;
    }
    final split = total / people.length;
    for (var p in people) {
      net[p] = net[p]! - split;
    }
    return net;
  }

  List<Transaction> minimumCashFlow() {
    final net = calculateNetBalances();
    final List<Transaction> settlements = [];

    List<MapEntry<Person, double>> positives =
    net.entries.where((e) => e.value > 0.01).toList()..sort((a,b)=>b.value.compareTo(a.value));
    List<MapEntry<Person, double>> negatives =
    net.entries.where((e) => e.value < -0.01).toList()..sort((a,b)=>a.value.compareTo(b.value));

    int i = 0, j = 0;
    while (i < positives.length && j < negatives.length) {
      final give = positives[i];
      final take = negatives[j];
      final amt = [give.value, -take.value].reduce((a,b)=>a<b?a:b);

      settlements.add(Transaction(take.key, give.key, amt));
      positives[i] = MapEntry(give.key, give.value - amt);
      negatives[j] = MapEntry(take.key, take.value + amt);

      if (positives[i].value <= 0.01) i++;
      if (negatives[j].value >= -0.01) j++;
    }
    return settlements;
  }
}
