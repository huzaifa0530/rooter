import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/FeedbackController.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'dart:convert';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _storage = const FlutterSecureStorage();
  final FeedbackController _feedbackController = Get.put(FeedbackController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return MainScaffold(
      title: 'contact_us'.tr,
      currentIndex: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'get_in_touch'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 8),
            Text('contact_subtext'.tr, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 30),
            _buildTextField(
              label: 'your_name'.tr,
              controller: _nameController,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'your_email'.tr,
              controller: _emailController,
              inputType: TextInputType.emailAddress,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextArea(
              label: 'your_message'.tr,
              controller: _messageController,
              theme: theme,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _messageController.text.isEmpty) {
                    Get.snackbar("Error", "All fields are required!");
                    return;
                  }

                  final userJson = await _storage.read(key: 'user');
                  int userId = 1; // default
                  if (userJson != null) {
                    final user = jsonDecode(userJson);
                    userId = user['id'] ?? 1;
                  }

                  final success = await _feedbackController.submitFeedback(
                    userId: userId,
                    name: _nameController.text,
                    email: _emailController.text,
                    msg: _messageController.text,
                  );

                  if (success) {
                    _messageController.clear(); // always clear message
                    // if you also want to clear name & email:
                    // _nameController.clear();
                    // _emailController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('send_message'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodySmall,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
  }) {
    return TextField(
      controller: controller,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        labelStyle: theme.textTheme.bodySmall,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
