import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/group_model.dart';
import '../../services/group_service.dart';
import '../widgets/neomorphic_appbar.dart';
import '../widgets/neomorphic_drawer.dart';
import '../widgets/neomorphic_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroupModel> groups = [];
  bool isLoading = true;
  double youOwe = 0;
  double owedToYou = 0;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    final res = await GroupService.fetchMyGroups();
    final summary = await GroupService.fetchBalanceSummary();

    if (!mounted) return;
    setState(() {
      groups = res;
      youOwe = summary['youOwe'] ?? 0;
      owedToYou = summary['owedToYou'] ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E5EC);
    final shadowDark = isDark ? Colors.black87 : const Color(0xFFA3B1C6);
    final shadowLight = isDark ? Colors.grey.shade800 : Colors.white;

    return Scaffold(
      appBar: const NeomorphicAppBar(title: 'BillPod Dashboard'),
      drawer: const NeomorphicDrawer(),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    "Welcome 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Here's your current balance summary",
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBalanceCard(cardColor, shadowDark, shadowLight),
                  const SizedBox(height: 30),
                  Text(
                    "Your Groups",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...groups.map(
                    (group) => GestureDetector(
                      onTap: () => context.push('/group', extra: group),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: shadowDark,
                              offset: const Offset(4, 4),
                              blurRadius: 8,
                            ),
                            BoxShadow(
                              color: shadowLight,
                              offset: const Offset(-4, -4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Type: ${group.groupType}",
                              style: TextStyle(
                                color: isDark ? Colors.grey : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      floatingActionButton: NeomorphicFAB(
        icon: Icons.add,
        onPressed: () => context.go('/create-group'),
      ),
    );
  }

  Widget _buildBalanceCard(Color bgColor, Color shadowDark, Color shadowLight) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            offset: const Offset(6, 6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-6, -6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                "You Owe",
                style: TextStyle(fontSize: 14, color: Colors.redAccent),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${youOwe.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                "Owed to You",
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${owedToYou.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
