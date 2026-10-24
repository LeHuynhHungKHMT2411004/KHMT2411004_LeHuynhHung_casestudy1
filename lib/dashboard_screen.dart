
import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/transaction_model.dart';
import 'transaction_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Map<String, dynamic>> transactions = [];

  double totalIncome = 0;
  double totalExpense = 0;

  bool isLoading = true;
  String? errorMessage;

  double get balance => totalIncome - totalExpense;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Đọc toàn bộ dữ liệu từ SQLite
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final transactionData =
      await dbHelper.getTransactionsWithCategory();

      final income = await dbHelper.getTotalIncome();

      final expense = await dbHelper.getTotalExpense();

      if (!mounted) return;

      setState(() {
        transactions = transactionData;
        totalIncome = income;
        totalExpense = expense;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Định dạng tiền: 50000 -> 50.000
  String formatMoney(double value) {
    final text = value.toStringAsFixed(0);

    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  // Đổi ngày yyyy-MM-dd thành dd/MM/yyyy
  String formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Mở màn hình thêm giao dịch
  Future<void> openAddTransaction() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    // Nếu đã lưu thành công thì đọc lại SQLite
    if (result == true && mounted) {
      await loadData();
    }
  }

  // Mở màn hình sửa giao dịch
  Future<void> openEditTransaction(
      Map<String, dynamic> item,
      ) async {
    final transaction = TransactionModel.fromMap(item);

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(
          transaction: transaction,
        ),
      ),
    );

    // Nếu đã sửa thành công thì cập nhật Dashboard
    if (result == true && mounted) {
      await loadData();
    }
  }

  // Chọn icon tương ứng với danh mục
  IconData getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Ăn uống':
        return Icons.restaurant;

      case 'Di chuyển':
        return Icons.directions_car;

      case 'Mua sắm':
        return Icons.shopping_cart;

      case 'Giáo dục':
        return Icons.school;

      case 'Lương':
        return Icons.attach_money;

      default:
        return Icons.category;
    }
  }

  // Thẻ hiển thị tổng thu nhập hoặc tổng chi tiêu
  Widget buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5EAF2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '${formatMoney(amount)} đ',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị một giao dịch
  Widget buildTransactionItem(
      Map<String, dynamic> item,
      ) {
    final bool isIncome = item['type'] == 'income';

    final double amount =
    (item['amount'] as num).toDouble();

    final String category =
        item['category_name']?.toString() ?? 'Khác';

    final String note =
        item['note']?.toString().trim() ?? '';

    final String date =
    formatDate(item['date']?.toString() ?? '');

    final Color amountColor = isIncome
        ? const Color(0xFF239A4A)
        : const Color(0xFFE74C3C);

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Color(0xFFE5EAF2),
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),

        onTap: () => openEditTransaction(item),

        leading: CircleAvatar(
          radius: 23,
          backgroundColor: isIncome
              ? const Color(0xFFE2F5E9)
              : const Color(0xFFFFE9E8),

          child: Icon(
            getCategoryIcon(category),
            color: amountColor,
          ),
        ),

        title: Text(
          note.isEmpty ? category : note,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '$category • $date',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),

        trailing: Text(
          '${isIncome ? '+' : '-'}${formatMoney(amount)} đ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ),
    );
  }

  // Giao diện chính Dashboard
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          'Expense Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,

        actions: [
          IconButton(
            onPressed: loadData,
            tooltip: 'Làm mới dữ liệu',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddTransaction,
        backgroundColor: const Color(0xFF2166DB),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),

              const SizedBox(height: 12),

              const Text(
                'Không thể tải dữ liệu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: loadData,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: loadData,

        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(18),

          children: [
            // Thẻ số dư
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: const Color(0xFF2166DB),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),

                      SizedBox(width: 8),

                      Text(
                        'Số dư hiện tại',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,

                    child: Text(
                      '${formatMoney(balance)} đ',

                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Tổng thu nhập và chi tiêu
            Row(
              children: [
                buildSummaryCard(
                  title: 'Thu nhập',
                  amount: totalIncome,
                  icon: Icons.arrow_downward,
                  color: const Color(0xFF239A4A),
                ),

                const SizedBox(width: 12),

                buildSummaryCard(
                  title: 'Chi tiêu',
                  amount: totalExpense,
                  icon: Icons.arrow_upward,
                  color: const Color(0xFFE74C3C),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Tiêu đề danh sách giao dịch
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${transactions.length} giao dịch',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Danh sách giao dịch từ SQLite
            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 45,
                  horizontal: 20,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 55,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Chưa có giao dịch nào',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      'Nhấn nút + để thêm giao dịch đầu tiên',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...transactions.map(
                    (item) => buildTransactionItem(item),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
