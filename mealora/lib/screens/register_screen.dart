import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _snack('Vui lòng nhập đầy đủ thông tin');
      return;
    }
    if (!email.contains('@')) {
      _snack('Email không hợp lệ');
      return;
    }
    if (password.length < 6) {
      _snack('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }
    if (password != confirm) {
      _snack('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _loading = true);
    final user = await DatabaseService.instance.registerUser(
      email: email,
      password: password,
      fullName: name,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (user == null) {
      _snack('Email này đã được đăng ký, vui lòng dùng email khác');
      return;
    }

    await SessionController.instance.startSession(user);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
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
                  _field(hint: 'Họ và tên', icon: Icons.person_outline,
                      controller: _nameCtrl),
                  const SizedBox(height: 16),
                  _field(
                      hint: 'Email',
                      icon: Icons.mail_outline,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _field(
                    hint: 'Mật khẩu',
                    icon: Icons.lock_outline,
                    controller: _passwordCtrl,
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
                      controller: _confirmCtrl,
                      obscure: true),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: _loading ? 'Đang đăng ký...' : 'Đăng ký',
                    radius: 12,
                    onPressed: _loading ? null : _register,
                  ),
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
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
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
