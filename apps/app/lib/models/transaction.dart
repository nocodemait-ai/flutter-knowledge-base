class Transaction {
  final String id;
  final double amount;
  final String category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        category: json['category'] as String,
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      };

  Transaction copyWith({double? amount, String? category, DateTime? date}) =>
      Transaction(
        id: id,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        date: date ?? this.date,
      );
}