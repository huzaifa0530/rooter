import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final LoginController loginController = Get.put(LoginController());

  late AnimationController _logoCtrl;
  late Animation<double> _logoAnim;

  late AnimationController _formCtrl;
  late Animation<double> _formFade;

  bool _obscurePwd = true;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _logoAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );

    _formCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _formFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formCtrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _formCtrl.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required ThemeData theme,
    bool isPassword = false,
    VoidCallback? toggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: label == 'Email'
              ? loginController.emailController
              : loginController.passwordController,
          obscureText: isPassword ? _obscurePwd : false,
          keyboardType: label == 'Email'
              ? TextInputType.emailAddress
              : TextInputType.text,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter your ${label.toLowerCase()}',
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(icon, color: Colors.black),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePwd ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: toggleObscure,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 40),
                  child: ScaleTransition(
                    scale: _logoAnim,
                    child: Image.asset('assets/images/logo.png', height: 100),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Rooster!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                // const Text(
                //   'The best fried chicken and juicy burgers\njust a tap away.',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.black87,
                //   ),
                // ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _formFade,
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Email',
                        icon: Icons.person,
                        theme: theme,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Password',
                        icon: Icons.lock,
                        theme: theme,
                        isPassword: true,
                        toggleObscure: () =>
                            setState(() => _obscurePwd = !_obscurePwd),
                      ),
                      const SizedBox(height: 30),
                      Obx(() => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: loginController.isLoading.value
                                  ? null
                                  : loginController.loginUser,
                              child: loginController.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          )),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
