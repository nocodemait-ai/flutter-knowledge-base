import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionService extends ChangeNotifier {
  final List<Transaction> _items = [
    Transaction(id: 't_001', amount: 45.50, category: 'Groceries', date: DateTime(2024, 5, 15)),
    Transaction(id: 't_002', amount: 120.00, category: 'Rent', date: DateTime(2024, 5, 1)),
    Transaction(id: 't_003', amount: 15.99, category: 'Streaming', date: DateTime(2024, 5, 2)),
    Transaction(id: 't_004', amount: 85.00, category: 'Fuel', date: DateTime(2024, 5, 5)),
    Transaction(id: 't_005', amount: 300.00, category: 'Insurance', date: DateTime(2024, 5, 10)),
    Transaction(id: 't_006', amount: 22.40, category: 'Coffee', date: DateTime(2024, 5, 12)),
    Transaction(id: 't_007', amount: 50.00, category: 'Utilities', date: DateTime(2024, 5, 14)),
    Transaction(id: 't_008', amount: 12.00, category: 'Subscriptions', date: DateTime(2024, 5, 15)),
    Transaction(id: 't_009', amount: 99.00, category: 'Shopping', date: DateTime(2024, 5, 16)),
    Transaction(id: 't_010', amount: 7.50, category: 'Transport', date: DateTime(2024, 5, 17)),
  ];

  List<Transaction> get transactions => List.unmodifiable(_items);

  void addTransaction(Transaction t) {
    _items.add(t);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _items.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}