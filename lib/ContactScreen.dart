import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
            Text(
              'contact_subtext'.tr,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            _buildTextField(label: 'your_name'.tr, theme: theme),
            const SizedBox(height: 16),
            _buildTextField(
                label: 'your_email'.tr,
                inputType: TextInputType.emailAddress,
                theme: theme),
            const SizedBox(height: 16),
            _buildTextArea(label: 'your_message'.tr, theme: theme),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'thank_you'.tr,
                    'contact_response'.tr,
                    backgroundColor: primary,
                    colorText: Colors.white,
                  );
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
    required ThemeData theme,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
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
    required ThemeData theme,
  }) {
    return TextField(
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
