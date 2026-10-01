class TransactionModel {
  final int? id;
  final int categoryId;
  final String type;
  final double amount;
  final String date;
  final String? note;
  final String? createdAt;
  final String? updatedAt;

  TransactionModel({
    this.id,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.date,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'date': date,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory TransactionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TransactionModel(
      id: map['id'] as int?,
      categoryId: map['category_id'] as int,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      note: map['note'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }
}