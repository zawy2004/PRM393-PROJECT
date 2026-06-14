import 'package:flutter/material.dart';
import '../state/cart_controller.dart';
import '../state/favorites_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/food_card.dart';
import 'food_detail_screen.dart';

/// Màn hình các món yêu thích - lưới giống Home, cập nhật khi bỏ/thêm yêu thích.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final favCtrl = FavoritesController.instance;

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Món yêu thích'),
          Expanded(
            child: ListenableBuilder(
              listenable: favCtrl,
              builder: (context, _) {
                final favorites = favCtrl.favorites;
                if (favorites.isEmpty) return _buildEmpty(context);
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 169 / 210,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return FoodCard(
                      item: item,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FoodDetailScreen(
                            item: item,
                            onAddToCart: CartController.instance.add,
                          ),
                        ),
                      ),
                      onAdd: () => CartController.instance.add(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 64, color: palette.textHint),
          const SizedBox(height: 16),
          Text('Chưa có món yêu thích',
              style: AppTextStyles.subtitle
                  .copyWith(color: palette.textSecondary)),
        ],
      ),
    );
  }
}
