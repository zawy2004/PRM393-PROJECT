import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/primary_button.dart';
import 'main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _snack('Vui lòng nhập đầy đủ email và mật khẩu');
      return;
    }

    setState(() => _loading = true);
    final user = await DatabaseService.instance.login(email, password);
    if (!mounted) return;
    setState(() => _loading = false);

    if (user == null) {
      _snack('Email hoặc mật khẩu không đúng');
      return;
    }

    await SessionController.instance.startSession(user);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
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

              _InputField(
                hint: 'Email',
                icon: Icons.mail_outline,
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _InputField(
                hint: 'Mật khẩu',
                icon: Icons.lock_outline,
                controller: _passwordCtrl,
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

              PrimaryButton(
                label: _loading ? 'Đang đăng nhập...' : 'Đăng nhập',
                radius: 12,
                onPressed: _loading ? null : _login,
              ),
              const SizedBox(height: 28),

              Center(
                child: Text(
                  'hoặc tiếp tục với',
                  style: AppTextStyles.bodySmall.copyWith(color: palette.textHint),
                ),
              ),
              const SizedBox(height: 16),

              OutlineButton(
                label: 'Google',
                onPressed: _login,
                leading: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
              ),
              const SizedBox(height: 40),

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

class _InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const _InputField({
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
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
