class ExpenseModel {
  final String id;
  final String description;
  final double amount;
  final String paidByName;

  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidByName,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['_id'],
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paidByName: json['paidBy']['name'] ?? 'Unknown',
    );
  }
}
