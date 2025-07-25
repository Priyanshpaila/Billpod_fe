import 'package:billpod/providers/auth_provider.dart';
import 'package:billpod/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/api_endpoints.dart';
import '../../providers/user_provider.dart';

class NeomorphicDrawer extends ConsumerWidget {
  const NeomorphicDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : AppColors.base;
    final textColor = isDark ? Colors.white : Colors.black87;

    final user = ref.watch(userProvider);
    final image =
        user?.profileImage != null
            ? NetworkImage('${ApiEndpoints.imageBase}/${user!.profileImage}')
            : const AssetImage('assets/images/default_avatar.png')
                as ImageProvider;

    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(radius: 40, backgroundImage: image),
            const SizedBox(height: 12),
            Text(
              user?.name ?? 'Guest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            _buildNavTile(
              context,
              ref,
              Icons.home,
              "Home",
              '/home',
              textColor,
              bgColor,
            ),
            const Divider(thickness: 1),
            _buildNavTile(
              context,
              ref,
              Icons.group_add,
              "Create Group",
              '/create-group',
              textColor,
              bgColor,
            ),
            const Divider(thickness: 1),
            _buildNavTile(
              context,
              ref,
              Icons.account_circle,
              "Profile",
              '/profile',
              textColor,
              bgColor,
            ),
            const Divider(thickness: 1),
            _buildNavTile(
              context,
              ref,
              Icons.notifications,
              "Notifications",
              '/notifications',
              textColor,
              bgColor,
            ),
            const Divider(thickness: 1),
            _buildNavTile(
              context,
              ref,
              Icons.assessment,
              "Reports",
              '/reports',
              textColor,
              bgColor,
            ),
            const Spacer(),
            const Divider(thickness: 1),
            _buildNavTile(
              context,
              ref,
              Icons.logout,
              "Logout",
              '/logout',
              textColor,
              bgColor,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    String label,
    String route,
    Color textColor,
    Color tileColor,
  ) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(label, style: TextStyle(fontSize: 16, color: textColor)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: tileColor,
      onTap: () async {
        Navigator.pop(context); // Close drawer immediately

        if (route == '/logout') {
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
            const SnackBar(content: Text("Logging out...")),
          );

          // Defer logout + redirect logic to next frame
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // ✅ Perform backend logout and token cleanup
            await AuthService.logout();

            // ✅ Reset state
            ref.invalidate(userProvider);
            ref.invalidate(authProvider); // Optional: Clear auth status too

            // ✅ Redirect to auth
            if (context.mounted) {
              context.go('/auth');
            }
          });
        } else {
          context.go(route);
        }
      },
    );
  }
}
