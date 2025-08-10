import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/user_controller.dart';
import 'package:rooster/ContactScreen.dart';
import 'package:rooster/LoginScreen.dart';
import 'package:rooster/ProfileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userController = Get.find<UserController>();

    return Drawer(
      backgroundColor: colorScheme.background,
      child: Column(
        children: [
          Obx(() => UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: colorScheme.primary),
                accountName: Text(
                  userController.name.value.isNotEmpty
                      ? userController.name.value
                      : 'John Doe',
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  userController.email.value.isNotEmpty
                      ? userController.email.value
                      : 'john@example.com',
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child:
                      Icon(Icons.person, color: colorScheme.primary, size: 40),
                ),
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  label: 'profile'.tr,
                  onTap: () => Get.to(() => const ProfileScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.headset_mic_outlined,
                  label: 'contact_us'.tr,
                  onTap: () => Get.to(() => const ContactUsScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_outlined,
                  label: 'logout'.tr,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final theme = Theme.of(context);

    Get.defaultDialog(
      title: "Confirm Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: theme.primaryColor,
      cancelTextColor: theme.primaryColor,
      onConfirm: () async {
        final storage = FlutterSecureStorage();
        await storage.delete(key: 'token');
        await storage.delete(key: 'user');
        Get.offAll(() => const LoginScreen());
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onBackground,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      splashColor: colorScheme.primary.withOpacity(0.1),
      hoverColor: colorScheme.primary.withOpacity(0.05),
    );
  }
}
