import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';

/// Màn hình xem/sửa thông tin cá nhân: họ tên, số điện thoại (email cố định).
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = SessionController.instance.currentUser;
    _nameCtrl = TextEditingController(text: user?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = SessionController.instance.currentUser;
    if (user == null) return;

    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _snack('Vui lòng nhập họ tên');
      return;
    }

    setState(() => _saving = true);
    final updated = user.copyWith(
      fullName: name,
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
    );
    await DatabaseService.instance.updateUser(updated);
    SessionController.instance.updateCurrentUser(updated);

    if (!mounted) return;
    setState(() => _saving = false);
    _snack('Đã lưu thông tin cá nhân');
    Navigator.of(context).maybePop();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final email = SessionController.instance.currentUser?.email ?? '';
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Thông tin cá nhân'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _label(context, 'Email'),
                const SizedBox(height: 6),
                TextField(
                  controller: TextEditingController(text: email),
                  enabled: false,
                  decoration: _decoration(context),
                ),
                const SizedBox(height: 20),
                _label(context, 'Họ và tên'),
                const SizedBox(height: 6),
                TextField(controller: _nameCtrl, decoration: _decoration(context)),
                const SizedBox(height: 20),
                _label(context, 'Số điện thoại'),
                const SizedBox(height: 6),
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration(context),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: _saving ? 'Đang lưu...' : 'Lưu thay đổi',
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    final palette = context.palette;
    return Text(text,
        style: AppTextStyles.bodySmall.copyWith(color: palette.textSecondary));
  }

  InputDecoration _decoration(BuildContext context) {
    final palette = context.palette;
    return InputDecoration(
      filled: true,
      fillColor: palette.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.border),
      ),
    );
  }
}
