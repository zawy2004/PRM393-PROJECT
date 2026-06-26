import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

class _Faq {
  final String question;
  final String answer;
  const _Faq(this.question, this.answer);
}

/// Trợ giúp & hỗ trợ: FAQ tĩnh + liên hệ qua email/hotline.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<_Faq> _faqs = [
    _Faq('Làm sao để theo dõi đơn hàng?',
        'Vào tab Đơn hàng > chọn đơn đang giao > bấm "Theo dõi" để xem bản đồ '
            'và tiến trình giao hàng theo thời gian thực.'),
    _Faq('Tôi có thể hủy đơn không?',
        'Đơn hàng có thể hủy trong vòng 5 phút sau khi đặt, trước khi quán '
            'bắt đầu chuẩn bị. Liên hệ hotline để được hỗ trợ hủy đơn.'),
    _Faq('Thanh toán MoMo bị lỗi, phải làm sao?',
        'Kiểm tra kết nối mạng và thử lại. Nếu tiền đã bị trừ nhưng đơn chưa '
            'lên hệ thống, vui lòng gửi email kèm mã đơn để được hoàn tiền.'),
    _Faq('Làm sao đổi địa chỉ/phương thức thanh toán mặc định?',
        'Vào Hồ sơ > Địa chỉ giao hàng hoặc Phương thức thanh toán để thêm, '
            'sửa, xóa hoặc đặt mặc định.'),
  ];

  Future<void> _contactEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@mealora.app',
      query: 'subject=Hỗ trợ Mealora',
    );
    await launchUrl(uri);
  }

  Future<void> _contactPhone() async {
    final uri = Uri(scheme: 'tel', path: '19001234');
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Trợ giúp & hỗ trợ'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Câu hỏi thường gặp',
                    style: AppTextStyles.subtitle
                        .copyWith(color: palette.textPrimary)),
                const SizedBox(height: 12),
                ..._faqs.map((f) => _buildFaqTile(context, f)),
                const SizedBox(height: 20),
                Text('Liên hệ trực tiếp',
                    style: AppTextStyles.subtitle
                        .copyWith(color: palette.textPrimary)),
                const SizedBox(height: 12),
                _buildContactRow(context, Icons.mail_outline,
                    'support@mealora.app', _contactEmail),
                const SizedBox(height: 8),
                _buildContactRow(
                    context, Icons.phone_outlined, '1900 1234', _contactPhone),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, _Faq faq) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(faq.question,
            style: AppTextStyles.semibold14.copyWith(color: palette.textPrimary)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(faq.answer,
              style: AppTextStyles.bodySmall
                  .copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildContactRow(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: palette.primary),
        title: Text(label,
            style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary)),
        trailing: Icon(Icons.chevron_right, color: palette.textHint),
      ),
    );
  }
}
