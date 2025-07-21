import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';

  final secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userJson = await secureStorage.read(key: 'user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        userName = user['name'] ?? '';
        userEmail = user['email'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Locale? currentLocale = Get.locale;

    final List<Map<String, dynamic>> languages = [
      {
        'locale': const Locale('en', 'US'),
        'label': 'English',
        'icon': Icons.language,
      },
      {
        'locale': const Locale('de', 'DE'),
        'label': 'Deutsch',
        'icon': Icons.translate,
      },
    ];

    return MainScaffold(
      title: 'profile',
      currentIndex: 3,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Icon(Icons.person, size: 64, color: Colors.black54),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'profile'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 👇 Inject name/email from secure storage
            _buildProfileTile(
              icon: Icons.person,
              label: 'name'.tr,
              value: userName.isNotEmpty ? userName : '...',
            ),
            _buildProfileTile(
              icon: Icons.email,
              label: 'email'.tr,
              value: userEmail.isNotEmpty ? userEmail : '...',
            ),

            _buildProfileTile(
                icon: Icons.phone, label: 'phone'.tr, value: '+92 312 0000000'),
            _buildProfileTile(
                icon: Icons.store,
                label: 'restaurant_name'.tr,
                value: 'Rooster Islamabad'),
            _buildProfileTile(
                icon: Icons.location_on,
                label: 'address'.tr,
                value: 'F-10 Markaz, Islamabad'),
            _buildProfileTile(
                icon: Icons.location_city,
                label: 'city'.tr,
                value: 'Islamabad'),

            const SizedBox(height: 32),
            Text(
              'choose_language'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...languages.map((lang) {
              final bool isSelected = currentLocale == lang['locale'];

              return Card(
                color: isSelected
                    ? theme.colorScheme.secondary.withOpacity(0.1)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(lang['icon'], color: theme.primaryColor),
                  title: Text(
                    lang['label'],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: theme.primaryColor)
                      : null,
                  onTap: () => Get.updateLocale(lang['locale']),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
