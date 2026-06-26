import 'package:momo_payment_flutter/momo_payment_flutter.dart';

/// Bọc [MomoPayment] với bộ test credential sandbox CÔNG KHAI do MoMo cung cấp
/// cho mục đích demo/học tập (https://test-payment.momo.vn).
///
/// KHÔNG dùng các giá trị này cho production - khi triển khai thật, đăng ký
/// merchant tại https://business.momo.vn để lấy partnerCode/accessKey/secretKey
/// riêng và thay thế ở đây.
class MomoService {
  MomoService._();
  static final MomoService instance = MomoService._();

  static const _partnerCode = 'MOMO';
  static const _accessKey = 'F8BBA842ECF85';
  static const _secretKey = 'K951B6PE1waDMi640xX08PD3vg6EkVlz';

  /// Deep link app quay lại sau khi người dùng thanh toán xong trên MoMo.
  static const redirectUrl = 'momopayment://return';

  /// MoMo yêu cầu khai báo URL nhận webhook (IPN) - dùng placeholder cho demo
  /// vì app không có backend lắng nghe callback.
  static const ipnUrl = 'https://example.com/momo_ipn';

  final MomoPayment momo = MomoPayment(
    partnerCode: _partnerCode,
    accessKey: _accessKey,
    secretKey: _secretKey,
    isTestMode: true,
    isDebug: true,
  );
}
