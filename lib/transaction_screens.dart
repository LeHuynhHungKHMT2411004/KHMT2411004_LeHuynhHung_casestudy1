import 'package:flutter/material.dart';

const primaryBlue = Color(0xFF2166DB);
const expenseRed = Color(0xFFFF686D);
const darkText = Color(0xFF1E2B45);

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionForm(isEditing: false);
  }
}

class EditTransactionScreen extends StatelessWidget {
  const EditTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionForm(isEditing: true);
  }
}

class TransactionForm extends StatefulWidget {
  final bool isEditing;

  const TransactionForm({
    super.key,
    required this.isEditing,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isExpense = true;
  String category = 'Ăn uống';
  DateTime date = DateTime(2025, 4, 12);

  late final TextEditingController amountController;
  late final TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.isEditing ? '100.000' : '',
    );
    noteController = TextEditingController(
      text: widget.isEditing ? 'Ăn trưa' : '',
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() => date = result);
    }
  }

  InputDecoration fieldDecoration({
    String? hint,
    Widget? suffix,
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF8994A8)),
      prefixIcon: prefix,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFFD5DEEC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: primaryBlue),
      ),
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
      ),
    );
  }

  Widget typeButton(String label, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpense = label == 'Chi tiêu';
            category = isExpense ? 'Ăn uống' : 'Lương';
          });
        },
        child: Container(
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? expenseRed : Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected
                  ? expenseRed
                  : const Color(0xFFD5DEEC),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : darkText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void saveTransaction() {
    if (amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing
              ? 'Đã lưu thay đổi (bản demo)'
              : 'Đã nhập giao dịch (bản demo)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = isExpense
        ? ['Ăn uống', 'Mua sắm', 'Di chuyển', 'Giải trí', 'Khác']
        : ['Lương', 'Thưởng', 'Đầu tư', 'Khác'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch',
          style: const TextStyle(
            color: darkText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Nút mở màn hình sửa để kiểm tra bài tập.
        actions: widget.isEditing
            ? null
            : [
          IconButton(
            tooltip: 'Xem màn hình sửa',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditTransactionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),

                        // Chi tiêu / Thu nhập
                        Row(
                          children: [
                            typeButton('Chi tiêu', isExpense),
                            const SizedBox(width: 5),
                            typeButton('Thu nhập', !isExpense),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Danh mục
                        fieldLabel('Danh mục'),
                        DropdownButtonFormField<String>(
                          value: category,
                          decoration: fieldDecoration(
                            prefix: Icon(
                              isExpense
                                  ? Icons.restaurant
                                  : Icons.attach_money,
                              color: expenseRed,
                            ),
                          ),
                          items: categories.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => category = value);
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Số tiền
                        fieldLabel('Số tiền'),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: fieldDecoration(
                            hint: 'Nhập số tiền',
                            suffix: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'đ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF65748B),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Ngày giao dịch
                        fieldLabel('Ngày giao dịch'),
                        InkWell(
                          onTap: selectDate,
                          child: InputDecorator(
                            decoration: fieldDecoration(
                              suffix: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF65748B),
                              ),
                            ),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: darkText,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Ghi chú
                        fieldLabel('Ghi chú'),
                        TextField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: fieldDecoration(
                            hint: 'Nhập ghi chú (tùy chọn)',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Nút lưu luôn nằm ở cuối màn hình
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: const Text(
                          'Lưu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}