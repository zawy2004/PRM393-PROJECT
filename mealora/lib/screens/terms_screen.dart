import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

class _Section {
  final String title;
  final String body;
  const _Section(this.title, this.body);
}

/// Điều khoản & chính sách - nội dung tĩnh cho bản demo.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const List<_Section> _sections = [
    _Section('1. Tài khoản',
        'Bạn chịu trách nhiệm bảo mật thông tin đăng nhập của mình. Mealora '
            'có quyền tạm khóa tài khoản nếu phát hiện hành vi gian lận.'),
    _Section('2. Đặt hàng & thanh toán',
        'Đơn hàng được xác nhận sau khi thanh toán thành công. Giá hiển thị '
            'đã bao gồm các loại thuế áp dụng, chưa bao gồm phí giao hàng '
            '(nếu có) tùy theo gói bạn chọn.'),
    _Section('3. Giao hàng',
        'Thời gian giao hàng dự kiến hiển thị trong mục theo dõi đơn mang '
            'tính ước lượng, có thể thay đổi do điều kiện giao thông/thời tiết.'),
    _Section('4. Hủy & hoàn tiền',
        'Đơn có thể hủy trong 5 phút sau khi đặt. Sau thời gian này, vui '
            'lòng liên hệ hỗ trợ để được xem xét từng trường hợp.'),
    _Section('5. Quyền riêng tư',
        'Thông tin cá nhân (họ tên, email, địa chỉ, số điện thoại) chỉ được '
            'dùng để xử lý đơn hàng và liên hệ giao hàng, không chia sẻ cho '
            'bên thứ ba ngoài mục đích vận chuyển.'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Điều khoản & chính sách'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Cập nhật lần cuối: 25/06/2026',
                    style: AppTextStyles.caption.copyWith(color: palette.textHint)),
                const SizedBox(height: 16),
                ..._sections.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.title,
                              style: AppTextStyles.semibold15
                                  .copyWith(color: palette.textPrimary)),
                          const SizedBox(height: 6),
                          Text(s.body,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: palette.textSecondary, height: 1.5)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
