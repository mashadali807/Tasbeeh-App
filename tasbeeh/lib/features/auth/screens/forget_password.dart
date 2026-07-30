import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/auth/widgets/auth_button.dart';
import 'package:tasbeeh/features/auth/widgets/auth_text_field.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              AuthTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              Obx(
                () => AuthButton(
                  text: 'Send Reset Link',
                  isLoading: authController.isLoading.value,
                  onPressed: () =>
                      authController.resetPassword(emailController.text.trim()),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.offAllNamed(Routes.login),
                  child: const Text('Back to Login'),
                ),
              ),
              Obx(() {
                if (authController.errorMessage.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      authController.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
