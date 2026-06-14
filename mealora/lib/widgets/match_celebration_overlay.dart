import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'food_image.dart';

/// Lớp phủ "It's a Match!" với pháo giấy khi người dùng thích một món.
/// Hiển thị preview món + nút "Xem yêu thích" / "Tiếp tục vuốt".
class MatchCelebrationOverlay extends StatefulWidget {
  final FoodItem item;
  final VoidCallback onKeepSwiping;
  final VoidCallback onSeeLiked;

  const MatchCelebrationOverlay({
    super.key,
    required this.item,
    required this.onKeepSwiping,
    required this.onSeeLiked,
  });

  @override
  State<MatchCelebrationOverlay> createState() =>
      _MatchCelebrationOverlayState();
}

class _MatchCelebrationOverlayState extends State<MatchCelebrationOverlay>
    with TickerProviderStateMixin {
  late final ConfettiController _confetti;
  late final AnimationController _bgAnim;
  late final AnimationController _cardAnim;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardSlide;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3))
      ..play();
    _bgAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
    _cardAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _cardScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnim, curve: Curves.elasticOut),
    );
    _cardSlide = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _cardAnim, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _confetti.dispose();
    _bgAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _bgAnim,
      child: GestureDetector(
        onTap: widget.onKeepSwiping,
        child: Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.88),
          body: Stack(
            alignment: Alignment.center,
            children: [
              // Pháo giấy nổ từ trên xuống.
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 40,
                  gravity: 0.3,
                  shouldLoop: false,
                  colors: const [
                    Color(0xFF2EB878),
                    Color(0xFFFF4081),
                    Color(0xFFFFD700),
                    Color(0xFF2196F3),
                    Colors.white,
                  ],
                ),
              ),
              // Thẻ nội dung có animation phóng + trượt lên.
              AnimatedBuilder(
                animation: _cardAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _cardSlide.value),
                  child: Transform.scale(scale: _cardScale.value, child: child),
                ),
                child: _buildCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('😋', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 8),
          const Text(
            'Ngon đấy!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Đã thêm vào danh sách yêu thích',
            style:
                TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
          ),
          const SizedBox(height: 28),
          // Preview món ăn.
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FoodImage(imageUrl: widget.item.imageUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                        colors: [Colors.transparent, Color(0xCC000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      widget.item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Nút hành động.
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onSeeLiked,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2EB878),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.favorite_rounded),
              label: const Text('Xem yêu thích',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onKeepSwiping,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Tiếp tục vuốt', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
