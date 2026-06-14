import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import 'main_shell.dart';

/// Màn hình đăng ký: họ tên, email, mật khẩu, xác nhận mật khẩu.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscure = true;

  void _register() {
    // Bỏ qua xác thực - vào thẳng app demo.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.surface,
      body: Column(
        children: [
          const AppHeader(title: 'Tạo tài khoản'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bắt đầu hành trình healthy',
                      style: AppTextStyles.headline
                          .copyWith(color: palette.textPrimary, fontSize: 24)),
                  const SizedBox(height: 8),
                  Text('Tạo tài khoản chỉ trong vài giây',
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: palette.textSecondary)),
                  const SizedBox(height: 32),
                  _field(hint: 'Họ và tên', icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _field(
                      hint: 'Email',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _field(
                    hint: 'Mật khẩu',
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: palette.textHint,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _field(
                      hint: 'Xác nhận mật khẩu',
                      icon: Icons.lock_outline,
                      obscure: true),
                  const SizedBox(height: 28),
                  PrimaryButton(
                      label: 'Đăng ký', radius: 12, onPressed: _register),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body
                              .copyWith(color: palette.textSecondary),
                          children: [
                            const TextSpan(text: 'Đã có tài khoản? '),
                            TextSpan(
                              text: 'Đăng nhập',
                              style: TextStyle(
                                color: palette.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    final palette = context.palette;
    return TextField(
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: palette.surfaceVariant,
        prefixIcon: Icon(icon, color: palette.textHint, size: 20),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: palette.textHint),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primary),
        ),
      ),
    );
  }
}
