import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/transaction_model.dart';

const primaryBlue = Color(0xFF2166DB);
const expenseRed = Color(0xFFFF686D);
const darkText = Color(0xFF1E2B45);

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionForm();
  }
}

class EditTransactionScreen extends StatelessWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionForm(
      transaction: transaction,
    );
  }
}

class TransactionForm extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionForm({
    super.key,
    this.transaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isExpense = true;

  int? selectedCategoryId;

  List<Map<String, dynamic>> categories = [];

  late TextEditingController amountController;
  late TextEditingController noteController;

  DateTime selectedDate = DateTime.now();

  bool loading = true;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    if (transaction != null) {
      isExpense = transaction.type == 'expense';

      selectedCategoryId = transaction.categoryId;

      amountController = TextEditingController(
        text: transaction.amount.toStringAsFixed(0),
      );

      noteController = TextEditingController(
        text: transaction.note ?? '',
      );

      selectedDate =
          DateTime.tryParse(transaction.date) ?? DateTime.now();
    } else {
      amountController = TextEditingController();
      noteController = TextEditingController();
    }

    loadCategories();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }

  Future<void> loadCategories() async {
    final result = await DatabaseHelper.instance.getCategoriesByType(
      isExpense ? 'expense' : 'income',
    );

    if (!mounted) return;

    setState(() {
      categories = result;

      final exists = result.any(
            (category) => category['id'] == selectedCategoryId,
      );

      if (!exists) {
        selectedCategoryId =
        result.isNotEmpty ? result.first['id'] as int : null;
      }

      loading = false;
    });
  }

  Future<void> changeType(bool expense) async {
    setState(() {
      isExpense = expense;
      selectedCategoryId = null;
      loading = true;
    });

    await loadCategories();
  }

  String databaseDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String displayDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> saveTransaction() async {
    if (selectedCategoryId == null) {
      return;
    }

    final amountText = amountController.text
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ'),
        ),
      );

      return;
    }

    final now = DateTime.now().toIso8601String();

    if (isEditing) {
      final old = widget.transaction!;

      final transaction = TransactionModel(
        id: old.id,
        categoryId: selectedCategoryId!,
        type: isExpense ? 'expense' : 'income',
        amount: amount,
        date: databaseDate(selectedDate),
        note: noteController.text.trim(),
        createdAt: old.createdAt,
        updatedAt: now,
      );

      await DatabaseHelper.instance.updateTransaction(
        transaction,
      );
    } else {
      final transaction = TransactionModel(
        categoryId: selectedCategoryId!,
        type: isExpense ? 'expense' : 'income',
        amount: amount,
        date: databaseDate(selectedDate),
        note: noteController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await DatabaseHelper.instance.insertTransaction(
        transaction,
      );
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  InputDecoration decoration({
    String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFD5DEEC),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        title: Text(
          isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => changeType(true),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpense
                          ? expenseRed
                          : Colors.white,

                      foregroundColor: isExpense
                          ? Colors.white
                          : darkText,
                    ),

                    child: const Text('Chi tiêu'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () => changeType(false),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isExpense
                          ? Colors.green
                          : Colors.white,

                      foregroundColor: !isExpense
                          ? Colors.white
                          : darkText,
                    ),

                    child: const Text('Thu nhập'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Danh mục',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: selectedCategoryId,

              decoration: decoration(),

              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category['id'] as int,
                  child: Text(
                    category['name'].toString(),
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Số tiền',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,

              decoration: decoration(
                hint: 'Nhập số tiền',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Ngày giao dịch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            InkWell(
              onTap: chooseDate,

              child: InputDecorator(
                decoration: decoration(),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      displayDate(selectedDate),
                    ),

                    const Icon(
                      Icons.calendar_month,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Ghi chú',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: noteController,

              maxLines: 3,

              decoration: decoration(
                hint: 'Nhập ghi chú',
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: saveTransaction,

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                ),

                child: Text(
                  isEditing
                      ? 'Lưu thay đổi'
                      : 'Thêm giao dịch',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}