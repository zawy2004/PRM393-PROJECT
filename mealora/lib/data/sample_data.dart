import 'package:flutter/material.dart';
import '../models/address.dart';
import '../models/food_item.dart';
import '../models/payment_method.dart';
import '../models/review.dart';

/// Dữ liệu mẫu tĩnh - sau này thay bằng dữ liệu từ API/Backend.
class SampleData {
  SampleData._();

  static const List<String> categories = [
    'Tất cả',
    'Low carb',
    'Protein',
    'Vegan',
    'Salad',
  ];

  // ---- Vài bộ review dùng lại cho các món ----
  static const List<Review> _reviewsA = [
    Review(
        author: 'Minh Anh',
        initials: 'M',
        rating: 5,
        comment: 'Món ăn tươi ngon, đóng gói đẹp, giao nhanh!',
        time: '2 ngày trước'),
    Review(
        author: 'Tuấn Kiệt',
        initials: 'T',
        rating: 4,
        comment: 'Khẩu phần hợp lý, sẽ đặt lại.',
        time: '5 ngày trước'),
    Review(
        author: 'Hồng Nhung',
        initials: 'H',
        rating: 5,
        comment: 'Healthy mà vẫn rất vừa miệng.',
        time: '1 tuần trước'),
  ];

  static const List<Review> _reviewsB = [
    Review(
        author: 'Quốc Bảo',
        initials: 'Q',
        rating: 5,
        comment: 'Protein nhiều, no lâu, rất đáng tiền.',
        time: '1 ngày trước'),
    Review(
        author: 'Lan Phương',
        initials: 'L',
        rating: 4,
        comment: 'Vị ổn, mong có thêm sốt.',
        time: '4 ngày trước'),
  ];

  static const List<FoodItem> foods = [
    FoodItem(
      id: 'f1',
      name: 'Salad gà nướng mật ong',
      calories: 380,
      price: 65000,
      imageUrl:
          'https://images.pexels.com/photos/28647073/pexels-photo-28647073.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Salad',
      rating: 4.8,
      reviewCount: 128,
      protein: 32,
      carbs: 28,
      fat: 12,
      description:
          'Salad gà nướng mật ong với rau xanh tươi, cà chua cherry, hạt óc '
          'chó và sốt mè rang. Thực đơn giàu protein, ít carb, phù hợp cho '
          'người ăn kiêng.',
      ingredients: [
        'Ức gà',
        'Rau xanh hỗn hợp',
        'Cà chua cherry',
        'Hạt óc chó',
        'Sốt mè',
      ],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f2',
      name: 'Cơm gạo lứt bò',
      calories: 420,
      price: 55000,
      imageUrl:
          'https://images.pexels.com/photos/31303466/pexels-photo-31303466.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.7,
      reviewCount: 96,
      protein: 35,
      carbs: 45,
      fat: 10,
      description:
          'Cơm gạo lứt ăn kèm thịt bò xào và rau củ, cân bằng dinh dưỡng cho '
          'bữa trưa năng lượng.',
      ingredients: ['Gạo lứt', 'Thịt bò', 'Bông cải', 'Cà rốt', 'Sốt teriyaki'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f3',
      name: 'Poke bowl cá hồi',
      calories: 450,
      price: 85000,
      imageUrl:
          'https://images.pexels.com/photos/15913488/pexels-photo-15913488.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.9,
      reviewCount: 210,
      protein: 30,
      carbs: 40,
      fat: 18,
      description:
          'Poke bowl cá hồi tươi với cơm, bơ, edamame và sốt mè Nhật Bản.',
      ingredients: ['Cá hồi', 'Cơm', 'Bơ', 'Edamame', 'Rong biển'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f4',
      name: 'Sandwich trứng',
      calories: 320,
      price: 45000,
      imageUrl:
          'https://images.pexels.com/photos/7663367/pexels-photo-7663367.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Low carb',
      rating: 4.5,
      reviewCount: 64,
      protein: 18,
      carbs: 30,
      fat: 14,
      description:
          'Sandwich trứng nguyên cám với rau và sốt bơ trứng, tiện lợi cho '
          'bữa sáng nhanh.',
      ingredients: ['Bánh mì nguyên cám', 'Trứng', 'Xà lách', 'Cà chua'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f5',
      name: 'Bowl đậu hũ rau củ',
      calories: 350,
      price: 50000,
      imageUrl:
          'https://images.pexels.com/photos/6271868/pexels-photo-6271868.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.6,
      reviewCount: 73,
      protein: 20,
      carbs: 38,
      fat: 11,
      description:
          'Bowl thuần chay với đậu hũ áp chảo, quinoa và rau củ theo mùa.',
      ingredients: ['Đậu hũ', 'Quinoa', 'Bí đỏ', 'Cải xoăn', 'Sốt tahini'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f6',
      name: 'Wrap gà cuốn rau',
      calories: 390,
      price: 60000,
      imageUrl:
          'https://images.pexels.com/photos/9624298/pexels-photo-9624298.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Low carb',
      rating: 4.7,
      reviewCount: 88,
      protein: 28,
      carbs: 26,
      fat: 15,
      description: 'Wrap gà nướng cuốn rau tươi, gọn nhẹ và giàu protein.',
      ingredients: ['Bánh tortilla', 'Gà nướng', 'Rau xanh', 'Sốt sữa chua'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f7',
      name: 'Salad cá ngừ',
      calories: 340,
      price: 70000,
      imageUrl:
          'https://images.pexels.com/photos/12173347/pexels-photo-12173347.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Salad',
      rating: 4.8,
      reviewCount: 102,
      protein: 34,
      carbs: 18,
      fat: 13,
      description:
          'Salad cá ngừ với trứng luộc, đậu và rau xanh, đậm vị mà ít calo.',
      ingredients: ['Cá ngừ', 'Trứng luộc', 'Đậu hà lan', 'Xà lách', 'Sốt dầu giấm'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f8',
      name: 'Ức gà sốt tiêu đen',
      calories: 410,
      price: 68000,
      imageUrl:
          'https://images.pexels.com/photos/6107757/pexels-photo-6107757.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.6,
      reviewCount: 77,
      protein: 40,
      carbs: 22,
      fat: 14,
      description:
          'Ức gà áp chảo sốt tiêu đen ăn kèm khoai lang và bông cải xanh.',
      ingredients: ['Ức gà', 'Khoai lang', 'Bông cải xanh', 'Sốt tiêu đen'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f9',
      name: 'Smoothie bowl xoài',
      calories: 300,
      price: 55000,
      imageUrl:
          'https://images.pexels.com/photos/4099238/pexels-photo-4099238.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.9,
      reviewCount: 156,
      protein: 8,
      carbs: 55,
      fat: 6,
      description:
          'Smoothie bowl xoài chuối phủ granola, hạt chia và dừa nạo.',
      ingredients: ['Xoài', 'Chuối', 'Granola', 'Hạt chia', 'Dừa nạo'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f10',
      name: 'Mì shirataki xào',
      calories: 280,
      price: 58000,
      imageUrl:
          'https://images.pexels.com/photos/2347311/pexels-photo-2347311.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Low carb',
      rating: 4.4,
      reviewCount: 51,
      protein: 22,
      carbs: 14,
      fat: 9,
      description:
          'Mì shirataki ít carb xào cùng tôm và rau củ, lý tưởng cho keto.',
      ingredients: ['Mì shirataki', 'Tôm', 'Ớt chuông', 'Hành tây', 'Sốt nấm'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f11',
      name: 'Cơm cuộn rau củ chay',
      calories: 310,
      price: 48000,
      imageUrl:
          'https://images.pexels.com/photos/7767695/pexels-photo-7767695.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.6,
      reviewCount: 67,
      protein: 9,
      carbs: 52,
      fat: 7,
      description:
          'Cơm cuộn rong biển với dưa leo, cà rốt, bơ và trứng chiên, thanh '
          'đạm và dễ ăn.',
      ingredients: ['Cơm', 'Rong biển', 'Dưa leo', 'Cà rốt', 'Bơ'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f12',
      name: 'Bò bít tết khoai tây nghiền',
      calories: 480,
      price: 95000,
      imageUrl:
          'https://images.pexels.com/photos/33144660/pexels-photo-33144660.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.8,
      reviewCount: 142,
      protein: 38,
      carbs: 30,
      fat: 22,
      description:
          'Bít tết bò áp chảo ăn kèm khoai tây nghiền kem béo và rau chân vịt.',
      ingredients: ['Thịt bò', 'Khoai tây', 'Rau chân vịt', 'Bơ', 'Tiêu đen'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f13',
      name: 'Bowl quinoa chay nhiều màu',
      calories: 360,
      price: 62000,
      imageUrl:
          'https://images.pexels.com/photos/17597408/pexels-photo-17597408.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.7,
      reviewCount: 91,
      protein: 13,
      carbs: 48,
      fat: 14,
      description:
          'Buddha bowl quinoa với bơ, đậu gà, khoai lang và rau chân vịt, '
          'đủ sắc màu và dinh dưỡng.',
      ingredients: ['Quinoa', 'Bơ', 'Đậu gà', 'Khoai lang', 'Rau chân vịt'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f14',
      name: 'Súp lơ xanh hấp',
      calories: 150,
      price: 35000,
      imageUrl:
          'https://images.pexels.com/photos/3872367/pexels-photo-3872367.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Low carb',
      rating: 4.4,
      reviewCount: 38,
      protein: 6,
      carbs: 18,
      fat: 4,
      description:
          'Súp lơ xanh và cà rốt hấp giữ nguyên dưỡng chất, món ăn kèm '
          'thanh nhẹ.',
      ingredients: ['Súp lơ xanh', 'Cà rốt', 'Dầu olive', 'Muối', 'Tiêu'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f15',
      name: 'Cá hồi nướng vỉ',
      calories: 430,
      price: 99000,
      imageUrl:
          'https://images.pexels.com/photos/36734954/pexels-photo-36734954.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.9,
      reviewCount: 175,
      protein: 36,
      carbs: 8,
      fat: 26,
      description:
          'Cá hồi nướng vỉ giữ trọn vị béo ngậy, ăn kèm rau củ nướng.',
      ingredients: ['Cá hồi', 'Chanh', 'Dầu olive', 'Rau củ nướng', 'Tiêu đen'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f16',
      name: 'Salad Hy Lạp phô mai feta',
      calories: 290,
      price: 58000,
      imageUrl:
          'https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Salad',
      rating: 4.7,
      reviewCount: 84,
      protein: 11,
      carbs: 16,
      fat: 20,
      description:
          'Salad kiểu Hy Lạp với phô mai feta, ô liu, cà chua và dưa leo, '
          'sốt dầu olive chua nhẹ.',
      ingredients: ['Phô mai feta', 'Ô liu', 'Cà chua', 'Dưa leo', 'Dầu olive'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f17',
      name: 'Sandwich rau củ sốt hummus',
      calories: 330,
      price: 47000,
      imageUrl:
          'https://images.pexels.com/photos/17430516/pexels-photo-17430516.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.5,
      reviewCount: 56,
      protein: 12,
      carbs: 42,
      fat: 10,
      description:
          'Sandwich nguyên cám với rau củ tươi và sốt hummus béo bùi, '
          'thuần chay.',
      ingredients: ['Bánh mì nguyên cám', 'Sốt hummus', 'Cà chua', 'Xà lách', 'Dưa leo'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f18',
      name: 'Tôm xào rau củ thập cẩm',
      calories: 360,
      price: 78000,
      imageUrl:
          'https://images.pexels.com/photos/36865007/pexels-photo-36865007.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.6,
      reviewCount: 69,
      protein: 30,
      carbs: 20,
      fat: 14,
      description:
          'Tôm xào cùng bông cải, nấm và rau củ thập cẩm, đậm vị mà vẫn '
          'nhẹ bụng.',
      ingredients: ['Tôm', 'Bông cải', 'Nấm', 'Ớt chuông', 'Sốt tỏi'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f19',
      name: 'Bơ trứng kiểu bữa sáng',
      calories: 310,
      price: 52000,
      imageUrl:
          'https://images.pexels.com/photos/4491279/pexels-photo-4491279.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Salad',
      rating: 4.6,
      reviewCount: 47,
      protein: 16,
      carbs: 14,
      fat: 22,
      description:
          'Bơ, trứng và cà chua bi trộn cùng rau xanh - bữa sáng nhanh mà '
          'vẫn đủ chất.',
      ingredients: ['Bơ', 'Trứng', 'Cà chua bi', 'Rau xanh', 'Dầu olive'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f20',
      name: 'Sườn cừu nướng rau củ',
      calories: 460,
      price: 110000,
      imageUrl:
          'https://images.pexels.com/photos/5410460/pexels-photo-5410460.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Protein',
      rating: 4.8,
      reviewCount: 53,
      protein: 34,
      carbs: 12,
      fat: 30,
      description:
          'Sườn cừu nướng thảo mộc ăn kèm cà chua bi và sốt đặc biệt, đậm '
          'đà hương vị.',
      ingredients: ['Sườn cừu', 'Thảo mộc', 'Cà chua bi', 'Tỏi', 'Sốt nướng'],
      reviews: _reviewsB,
    ),
    FoodItem(
      id: 'f21',
      name: 'Cơm chiên rau củ',
      calories: 340,
      price: 42000,
      imageUrl:
          'https://images.pexels.com/photos/3926124/pexels-photo-3926124.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.3,
      reviewCount: 61,
      protein: 8,
      carbs: 58,
      fat: 9,
      description:
          'Cơm chiên cùng rau củ tươi và cà chua, đơn giản mà vẫn ngon '
          'miệng.',
      ingredients: ['Cơm', 'Cà rốt', 'Đậu hà lan', 'Cà chua', 'Hành lá'],
      reviews: _reviewsA,
    ),
    FoodItem(
      id: 'f22',
      name: 'Yến mạch ngâm hạt chia',
      calories: 260,
      price: 38000,
      imageUrl:
          'https://images.pexels.com/photos/2147647/pexels-photo-2147647.jpeg?auto=compress&cs=tinysrgb&w=600',
      category: 'Vegan',
      rating: 4.7,
      reviewCount: 72,
      protein: 9,
      carbs: 40,
      fat: 7,
      description:
          'Yến mạch ngâm sữa hạt và hạt chia qua đêm, mát lạnh và tiện lợi '
          'cho buổi sáng.',
      ingredients: ['Yến mạch', 'Hạt chia', 'Sữa hạt', 'Mật ong'],
      reviews: _reviewsB,
    ),
  ];

  /// Tìm món theo id (trả về null nếu không có).
  static FoodItem? findById(String id) {
    for (final f in foods) {
      if (f.id == id) return f;
    }
    return null;
  }

  // ---- Địa chỉ giao hàng ----
  static const List<Address> addresses = [
    Address(
        label: 'Nhà',
        detail: '123 Nguyễn Văn Cừ, P.4, Q.5, TP.HCM',
        isDefault: true),
    Address(label: 'Công ty', detail: 'Tầng 8, Tòa Bitexco, Q.1, TP.HCM'),
  ];

  // ---- Phương thức thanh toán ----
  static const List<PaymentMethod> paymentMethods = [
    PaymentMethod(icon: Icons.money, label: 'Tiền mặt', detail: 'Khi nhận hàng'),
    PaymentMethod(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Ví MoMo',
        detail: '**** 8842'),
    PaymentMethod(
        icon: Icons.credit_card,
        label: 'Thẻ tín dụng',
        detail: 'Visa **** 1234'),
  ];

  // ---- Thông báo ----
  static const List<AppNotification> notifications = [
    AppNotification(
      title: 'Đơn hàng đang được giao',
      description: 'Shipper đang trên đường giao đơn #MP001 đến bạn.',
      time: '5 phút trước',
      icon: Icons.delivery_dining,
      unread: true,
    ),
    AppNotification(
      title: 'Ưu đãi mới',
      description: 'Giảm 20% cho gói tháng khi đặt trước thứ 2.',
      time: '1 giờ trước',
      icon: Icons.local_offer_outlined,
      unread: true,
    ),
    AppNotification(
      title: 'Đơn hàng hoàn thành',
      description: 'Đơn #MP002 đã được giao thành công. Đánh giá ngay nhé!',
      time: '2 ngày trước',
      icon: Icons.check_circle_outline,
    ),
    AppNotification(
      title: 'Thực đơn tuần mới',
      description: 'Khám phá 12 món healthy mới cho tuần này.',
      time: '3 ngày trước',
      icon: Icons.restaurant_menu,
    ),
    AppNotification(
      title: 'Nhắc nhở đặt suất ăn',
      description: 'Đừng quên đặt suất ăn cho ngày mai!',
      time: '4 ngày trước',
      icon: Icons.notifications_active_outlined,
    ),
    AppNotification(
      title: 'Tích điểm thành viên',
      description: 'Bạn vừa nhận được 50 điểm thưởng.',
      time: '1 tuần trước',
      icon: Icons.card_giftcard,
    ),
  ];

}

/// Một dòng trong giỏ hàng (món ăn + số lượng).
class CartLine {
  final FoodItem item;
  int quantity;

  CartLine({required this.item, this.quantity = 1});

  int get lineTotal => item.price * quantity;
}

/// Thông báo trong màn hình Notifications.
class AppNotification {
  final String title;
  final String description;
  final String time;
  final bool unread;
  final IconData icon;

  const AppNotification({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.unread = false,
  });
}
