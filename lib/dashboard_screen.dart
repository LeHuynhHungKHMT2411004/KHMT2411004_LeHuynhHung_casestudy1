
import 'package:flutter/material.dart';
import 'transaction_screens.dart';

const blue = Color(0xFF2166DB);
const dark = Color(0xFF18243A);

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedTab = 0;

  final transactions = const [
    _Transaction(
      'Ăn trưa', 'Ăn uống', '08/09/2024',
      '-50.000 đ', Icons.restaurant, Color(0xFFFF751F), false,
    ),
    _Transaction(
      'Xăng xe', 'Di chuyển', '03/09/2024',
      '-100.000 đ', Icons.directions_car, Color(0xFF2786EF), false,
    ),
    _Transaction(
      'Lương tháng 9', 'Thu nhập', '01/09/2024',
      '+8.000.000 đ', Icons.attach_money, Color(0xFF239A4A), true,
    ),
    _Transaction(
      'Mua sắm', 'Mua sắm', '31/08/2024',
      '-300.000 đ', Icons.shopping_cart, Color(0xFFA53CEB), false,
    ),
    _Transaction(
      'Học phí', 'Giáo dục', '30/08/2024',
      '-500.000 đ', Icons.school, Color(0xFF008A8A), false,
    ),
  ];

  void openAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionScreen(),
      ),
    );
  }

  Widget walletIcon() {
    return SizedBox(
      width: 85,
      height: 78,
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 20,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                width: 46,
                height: 46,
                color: const Color(0xFF63CA83),
                child: const Icon(
                  Icons.attach_money,
                  color: Color(0xFF318B52),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 4,
            child: Container(
              width: 65,
              height: 47,
              decoration: BoxDecoration(
                color: const Color(0xFF183B7A),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 31,
                color: Color(0xFF76AAEA),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            child: Icon(
              Icons.monetization_on,
              color: Color(0xFFFFC32C),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget balanceCard() {
    return Container(
      height: 143,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4288F5), Color(0xFF1256D9)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'SỐ DƯ HIỆN TẠI',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.visibility_outlined,
                            color: Colors.white70,
                            size: 15,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '5.000.000 đ',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                walletIcon(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 13,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              for (int i = 0; i < 3; i++)
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget summaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(icon, color: color, size: 23),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8190A5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      amount,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionTile(_Transaction transaction) {
    return InkWell(
      onTap: () {
        // Mở màn hình sửa dữ liệu mẫu của buổi 3.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EditTransactionScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: transaction.color,
              child: Icon(
                transaction.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        transaction.category,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        transaction.date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              transaction.amount,
              style: TextStyle(
                color: transaction.isIncome
                    ? const Color(0xFF168A45)
                    : const Color(0xFFE63946),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      children: [
        balanceCard(),
        const SizedBox(height: 10),
        Row(
          children: [
            summaryCard(
              title: 'TỔNG THU NHẬP',
              amount: '8.000.000 đ',
              icon: Icons.arrow_circle_down,
              color: const Color(0xFF25A35A),
              background: const Color(0xFFEAF8F0),
            ),
            const SizedBox(width: 9),
            summaryCard(
              title: 'TỔNG CHI TIÊU',
              amount: '3.000.000 đ',
              icon: Icons.arrow_circle_up,
              color: const Color(0xFFF04E60),
              background: const Color(0xFFFFEDEF),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Giao dịch gần đây',
              style: TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => selectedTab = 1);
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 12,
                  color: blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        for (final item in transactions)
          transactionTile(item),
      ],
    );
  }

  Widget allTransactions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tất cả giao dịch',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        for (final item in transactions)
          transactionTile(item),
      ],
    );
  }

  Widget statisticsContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Thống kê thu chi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        const SizedBox(height: 20),
        const Card(
          child: ListTile(
            leading: Icon(
              Icons.trending_up,
              color: Colors.green,
            ),
            title: Text('Tổng thu nhập'),
            subtitle: Text('8.000.000 đ'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(
              Icons.trending_down,
              color: Colors.red,
            ),
            title: Text('Tổng chi tiêu'),
            subtitle: Text('3.000.000 đ'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(
              Icons.account_balance_wallet,
              color: blue,
            ),
            title: Text('Số dư'),
            subtitle: Text('5.000.000 đ'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: dark),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Quản lý thu chi',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chưa có thông báo mới'),
                ),
              );
            },
            icon: const Badge(
              smallSize: 8,
              child: Icon(
                Icons.notifications_none,
                color: dark,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Expense Manager',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              for (final item in [
                ('Trang chủ', Icons.home, 0),
                ('Giao dịch', Icons.receipt_long, 1),
                ('Thống kê', Icons.pie_chart, 2),
              ])
                ListTile(
                  leading: Icon(item.$2),
                  title: Text(item.$1),
                  onTap: () {
                    setState(() => selectedTab = item.$3);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedTab,
        children: [
          dashboardContent(),
          allTransactions(),
          statisticsContent(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAdd,
        backgroundColor: blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() => selectedTab = index);
        },
        selectedItemColor: blue,
        unselectedItemColor: const Color(0xFF7E899C),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}

class _Transaction {
  final String title;
  final String category;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;
  final bool isIncome;

  const _Transaction(
      this.title,
      this.category,
      this.date,
      this.amount,
      this.icon,
      this.color,
      this.isIncome,
      );
}
