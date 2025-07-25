import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_model.dart';
import '../../services/group_service.dart';
import '../../services/user_service.dart';
import '../widgets/neomorphic_appbar.dart';
import '../widgets/neomorphic_button.dart';
import '../widgets/neomorphic_input.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final currencyController = TextEditingController(text: 'INR');
  String groupType = 'Trip';
  bool loading = false;

  final groupTypes = ['Trip', 'Home', 'Office', 'Custom'];

  List<UserModel> allUsers = [];
  List<String> selectedUserIds = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final users = await UserService.fetchAllUsers();
    if (!mounted) return;
    setState(() => allUsers = users);
  }

  void handleCreateGroup() async {
    if (!mounted) return;
    setState(() => loading = true);

    final res = await GroupService.createGroup(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      groupType: groupType,
      currency: currencyController.text.trim(),
      members: selectedUserIds,
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group created successfully.")),
      );
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeomorphicAppBar(title: 'Create Group', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          NeomorphicInput(controller: nameController, hint: "Group Name"),
          NeomorphicInput(controller: descriptionController, hint: "Description (optional)"),
          NeomorphicInput(controller: currencyController, hint: "Currency (e.g. INR)"),

          const SizedBox(height: 16),
          const Text("Group Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: groupTypes.map((type) {
              final isSelected = groupType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (_) => setState(() => groupType = type),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const Text("Add Members", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ...allUsers.map((user) {
            final isSelected = selectedUserIds.contains(user.id);
            return CheckboxListTile(
              value: isSelected,
              title: Text(user.name),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selectedUserIds.add(user.id);
                  } else {
                    selectedUserIds.remove(user.id);
                  }
                });
              },
            );
          }),

          const SizedBox(height: 24),
          loading
              ? const Center(child: CircularProgressIndicator())
              : NeomorphicButton(text: 'Create Group', onTap: handleCreateGroup),
        ],
      ),
    );
  }
}
