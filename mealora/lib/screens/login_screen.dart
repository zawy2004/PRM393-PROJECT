import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/primary_button.dart';
import 'main_shell.dart';
import 'register_screen.dart';

/// Màn hình đăng nhập: tiêu đề chào mừng, ô email/mật khẩu,
/// nút đăng nhập, đăng nhập Google và link đăng ký.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _login() {
    // Bỏ qua xác thực - chuyển thẳng vào app demo.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào mừng bạn!',
                style: AppTextStyles.headline.copyWith(color: palette.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Đăng nhập để đặt suất ăn healthy',
                style: AppTextStyles.bodyLarge
                    .copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: 40),

              // Ô nhập email.
              _InputField(
                hint: 'Email',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Ô nhập mật khẩu kèm nút ẩn/hiện.
              _InputField(
                hint: 'Mật khẩu',
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: palette.textHint,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(label: 'Đăng nhập', radius: 12, onPressed: _login),
              const SizedBox(height: 28),

              // Đường kẻ "hoặc tiếp tục với".
              Center(
                child: Text(
                  'hoặc tiếp tục với',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: palette.textHint),
                ),
              ),
              const SizedBox(height: 16),

              OutlineButton(
                label: 'Google',
                onPressed: _login,
                leading: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
              ),
              const SizedBox(height: 40),

              // Link đăng ký.
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.body
                          .copyWith(color: palette.textSecondary),
                      children: [
                        const TextSpan(text: 'Chưa có tài khoản? '),
                        TextSpan(
                          text: 'Đăng ký ngay',
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
    );
  }
}

/// Ô nhập liệu bo góc dùng riêng cho màn Login.
class _InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _InputField({
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
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
