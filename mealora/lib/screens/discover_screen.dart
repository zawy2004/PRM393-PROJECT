import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../data/sample_data.dart';
import '../models/food_item.dart';
import '../state/favorites_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/food_swipe_card.dart';
import '../widgets/match_celebration_overlay.dart';
import '../widgets/swipe_action_buttons.dart';
import 'favorites_screen.dart';

/// Màn hình "Khám phá" kiểu Tinder dùng [CardSwiper]:
/// - Vuốt phải / lên = thích → thêm vào yêu thích + hiệu ứng "match".
/// - Vuốt trái = bỏ qua → nhãn "NOPE".
/// - Nút điều khiển: quay lại, bỏ qua, siêu thích, thích.
class DiscoverScreen extends StatefulWidget {
  /// Callback tùy chọn khi thích một món (VD: để thêm vào giỏ).
  final ValueChanged<FoodItem>? onLike;

  const DiscoverScreen({super.key, this.onLike});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  CardSwiperController _controller = CardSwiperController();
  final List<FoodItem> _deck = List.of(SampleData.foods);
  bool _isDeckEmpty = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Xử lý mỗi lần vuốt; trả về true để xác nhận cho CardSwiper.
  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection dir) {
    final item = _deck[previousIndex];
    if (dir == CardSwiperDirection.right || dir == CardSwiperDirection.top) {
      _like(item);
    } else if (dir == CardSwiperDirection.left) {
      _showSwipeLabel(liked: false);
    }
    // Hết thẻ.
    if (currentIndex == null) setState(() => _isDeckEmpty = true);
    return true;
  }

  /// Hoàn tác lần vuốt gần nhất; nếu trước đó là "thích" thì bỏ yêu thích.
  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection dir) {
    if (dir == CardSwiperDirection.right || dir == CardSwiperDirection.top) {
      FavoritesController.instance.toggle(_deck[currentIndex].id);
    }
    return true;
  }

  void _like(FoodItem item) {
    FavoritesController.instance.add(item.id);
    widget.onLike?.call(item);
    _showMatchCelebration(item);
  }

  void _restartDeck() {
    setState(() {
      _isDeckEmpty = false;
      _controller.dispose();
      _controller = CardSwiperController();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isDeckEmpty ? _buildDeckEmpty() : _buildSwipeDeck(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Khám phá',
              style:
                  AppTextStyles.greeting.copyWith(color: palette.textPrimary)),
          const SizedBox(height: 4),
          Text('Vuốt phải để thích, vuốt trái để bỏ qua',
              style: AppTextStyles.bodySmall
                  .copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSwipeDeck() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CardSwiper(
              controller: _controller,
              cardsCount: _deck.length,
              numberOfCardsDisplayed: _deck.length < 3 ? _deck.length : 3,
              backCardOffset: const Offset(0, 40),
              padding: EdgeInsets.zero,
              // Chỉ cho vuốt trái/phải/lên (không vuốt xuống).
              allowedSwipeDirection: const AllowedSwipeDirection.only(
                left: true,
                right: true,
                up: true,
              ),
              cardBuilder: (context, index, _, _) =>
                  FoodSwipeCard(item: _deck[index]),
              onSwipe: _onSwipe,
              onUndo: _onUndo,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SwipeActionButtons(
            onRewind: () => _controller.undo(),
            onDislike: () => _controller.swipe(CardSwiperDirection.left),
            onSuperLike: () => _controller.swipe(CardSwiperDirection.top),
            onLike: () => _controller.swipe(CardSwiperDirection.right),
          ),
        ),
      ],
    );
  }

  /// Hiệu ứng "match" toàn màn hình khi thích.
  void _showMatchCelebration(FoodItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, _, _) => MatchCelebrationOverlay(
          item: item,
          onKeepSwiping: () => Navigator.of(context).pop(),
          onSeeLiked: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            );
          },
        ),
      ),
    );
  }

  /// Nhãn "NOPE" thoáng qua khi vuốt trái.
  void _showSwipeLabel({required bool liked}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).size.height * 0.25,
        left: 0,
        right: 0,
        child: _SwipeLabel(liked: liked),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 600), entry.remove);
  }

  /// Trạng thái khi đã vuốt hết bộ thẻ.
  Widget _buildDeckEmpty() {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍽️', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text('Bạn đã xem hết món rồi!',
                style: AppTextStyles.subtitle
                    .copyWith(color: palette.textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Xem lại danh sách yêu thích hoặc bắt đầu lại.',
                style:
                    AppTextStyles.body.copyWith(color: palette.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _restartDeck,
              style: FilledButton.styleFrom(backgroundColor: palette.primary),
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Bắt đầu lại'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Nhãn "NOPE" hiển thị thoáng qua giữa màn hình khi bỏ qua.
class _SwipeLabel extends StatefulWidget {
  final bool liked;
  const _SwipeLabel({required this.liked});

  @override
  State<_SwipeLabel> createState() => _SwipeLabelState();
}

class _SwipeLabelState extends State<_SwipeLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: widget.liked
                ? const Color(0xFF2EB878).withValues(alpha: 0.9)
                : const Color(0xFFF44336).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Text(
            widget.liked ? '❤️  THÍCH!' : '👎  BỎ QUA',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
      ),
    );
  }
}
