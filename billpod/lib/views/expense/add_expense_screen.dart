import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/group_model.dart';
import '../../services/expense_service.dart';
import '../widgets/neomorphic_appbar.dart';
import '../widgets/neomorphic_input.dart';
import '../widgets/neomorphic_button.dart';

class AddExpenseScreen extends StatefulWidget {
  final GroupModel group;

  const AddExpenseScreen({super.key, required this.group});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController(text: 'General');
  bool loading = false;

  // In production, get this from API
  String paidBy = 'me'; // mock user ID
  List<String> participants = ['me']; // mock user ID list

  void handleSubmit() async {
    if (!mounted) return;
    setState(() => loading = true);

    final res = await ExpenseService.createExpense(
      groupId: widget.group.id,
      amount: double.tryParse(amountController.text.trim()) ?? 0,
      description: descriptionController.text.trim(),
      category: categoryController.text.trim(),
      paidBy: paidBy,
      participants: participants,
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (res == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense added successfully.")),
      );
      context.pop(); // return to group detail
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeomorphicAppBar(title: 'Add Expense', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          NeomorphicInput(controller: amountController, hint: "Amount"),
          NeomorphicInput(controller: descriptionController, hint: "Description"),
          NeomorphicInput(controller: categoryController, hint: "Category"),
          const SizedBox(height: 20),
          loading
              ? const Center(child: CircularProgressIndicator())
              : NeomorphicButton(text: 'Add Expense', onTap: handleSubmit),
        ],
      ),
    );
  }
}
