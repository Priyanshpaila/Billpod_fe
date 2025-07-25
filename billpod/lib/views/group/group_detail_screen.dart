import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/group_model.dart';
import '../../models/expense_model.dart';
import '../../services/expense_service.dart';
import '../widgets/neomorphic_appbar.dart';
import '../widgets/neomorphic_fab.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List<ExpenseModel> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    final res = await ExpenseService.fetchExpenses(widget.group.id);
    if (!mounted) return;
    setState(() {
      expenses = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeomorphicAppBar(title: widget.group.name, showBack: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : expenses.isEmpty
              ? const Center(child: Text("No expenses yet."))
              : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: expenses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final exp = expenses[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E5EC),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFA3B1C6),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Paid by ${exp.paidByName} • ₹${exp.amount.toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: NeomorphicFAB(
        icon: Icons.add,
        onPressed: () {
          context.push('/add-expense', extra: widget.group);
        },
      ),
    );
  }
}
