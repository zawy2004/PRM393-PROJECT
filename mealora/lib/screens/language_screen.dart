import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

/// Chọn ngôn ngữ hiển thị. Lưu ý: toàn bộ nội dung app hiện chỉ có tiếng Việt,
/// nên màn này lưu lựa chọn (để sau này bật i18n) nhưng tiếng Anh đang
/// "Sắp ra mắt" - không giả vờ dịch khi tính năng chưa có.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const _prefsKey = 'app_language';
  String _selected = 'vi';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _selected = prefs.getString(_prefsKey) ?? 'vi');
  }

  Future<void> _select(String code) async {
    if (code != 'vi') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tiếng Anh sẽ có trong bản cập nhật tới.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
    if (!mounted) return;
    setState(() => _selected = code);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Ngôn ngữ'),
          _buildOption(context, 'vi', 'Tiếng Việt', enabled: true),
          _buildOption(context, 'en', 'English', enabled: false),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String code, String label,
      {required bool enabled}) {
    final palette = context.palette;
    final selected = _selected == code;
    return ListTile(
      onTap: () => _select(code),
      title: Text(label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: enabled ? palette.textPrimary : palette.textHint,
          )),
      subtitle: enabled ? null : Text('Sắp ra mắt',
          style: AppTextStyles.caption.copyWith(color: palette.textHint)),
      trailing: selected
          ? Icon(Icons.check_circle, color: palette.primary)
          : null,
    );
  }
}
