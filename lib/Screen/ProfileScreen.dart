import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rooster/widgets/MainScaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Info
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userAddress = '';
  String userStatus = '';

  // Franchise Info
  String franchiseName = '';
  String franchiseEmail = '';
  String franchisePhone = '';
  String franchiseAddress = '';
  String franchiseCity = '';
  String franchiseState = '';
  String franchiseCountry = '';

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
        // User Info
        userName = user['name'] ?? '';
        userEmail = user['email'] ?? '';
        userPhone = user['phone'] ?? '';
        userAddress = user['address'] ?? '';
        userStatus = user['status'] ?? '';

        // Franchise Info
        if (user['franchise'] != null) {
          franchiseName = user['franchise']['name'] ?? '';
          franchiseEmail = user['franchise']['email'] ?? '';
          franchisePhone = user['franchise']['phone'] ?? '';
          franchiseAddress = user['franchise']['address'] ?? '';
          franchiseCity = user['franchise']['city'] ?? '';
          franchiseState = user['franchise']['state'] ?? '';
          franchiseCountry = user['franchise']['country'] ?? '';
        }
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
      title: 'profile'.tr,
      currentIndex: 3,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
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

            // 👤 User Info
            Text("user_info".tr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildProfileTile(
                icon: Icons.person,
                label: 'name'.tr,
                value: userName.isNotEmpty ? userName : '...'),
            _buildProfileTile(
                icon: Icons.email,
                label: 'email'.tr,
                value: userEmail.isNotEmpty ? userEmail : '...'),
            _buildProfileTile(
                icon: Icons.phone,
                label: 'phone'.tr,
                value: userPhone.isNotEmpty ? userPhone : '...'),
            _buildProfileTile(
                icon: Icons.location_on,
                label: 'address'.tr,
                value: userAddress.isNotEmpty ? userAddress : '...'),
            _buildProfileTile(
                icon: Icons.verified_user,
                label: 'status'.tr,
                value: userStatus.isNotEmpty ? userStatus : '...'),

            const SizedBox(height: 24),

            // 🏢 Franchise Info
            Text("franchise_info".tr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildProfileTile(
                icon: Icons.store,
                label: 'restaurant_name'.tr,
                value: franchiseName.isNotEmpty ? franchiseName : '...'),
            _buildProfileTile(
                icon: Icons.email,
                label: 'email'.tr,
                value: franchiseEmail.isNotEmpty ? franchiseEmail : '...'),
            _buildProfileTile(
                icon: Icons.phone,
                label: 'phone'.tr,
                value: franchisePhone.isNotEmpty ? franchisePhone : '...'),
            _buildProfileTile(
                icon: Icons.location_on,
                label: 'address'.tr,
                value: franchiseAddress.isNotEmpty ? franchiseAddress : '...'),
            _buildProfileTile(
                icon: Icons.location_city,
                label: 'city'.tr,
                value: franchiseCity.isNotEmpty ? franchiseCity : '...'),
            _buildProfileTile(
                icon: Icons.map,
                label: 'state'.tr,
                value: franchiseState.isNotEmpty ? franchiseState : '...'),
            _buildProfileTile(
                icon: Icons.flag,
                label: 'country'.tr,
                value: franchiseCountry.isNotEmpty ? franchiseCountry : '...'),

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
                // color: isSelected
                //     ? theme.colorScheme.secondary.withOpacity(0.15)
                //     : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: isSelected
                      ? BorderSide(color: theme.primaryColor, width: 1)
                      : BorderSide.none,
                ),
                child: ListTile(
                  leading: Icon(lang['icon'], color: theme.primaryColor),
                  title: Text(
                    lang['label'],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.normal : FontWeight.normal,
                      color: isSelected ? theme.primaryColor : Colors.black,
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
