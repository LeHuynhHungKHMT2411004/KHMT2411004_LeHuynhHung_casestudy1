import 'package:flutter/material.dart';
import 'transaction_screens.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}

class ExpenseManagerPage extends StatelessWidget {
  const ExpenseManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Icon ví tiền
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 38),
                    decoration: BoxDecoration(
                      color: const Color(0xff7BC67B),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    width: 115,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xff1976D2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 43,
                      height: 27,
                      decoration: const BoxDecoration(
                        color: Color(0xff0D47A1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff14213D),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 4),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTransactionScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}