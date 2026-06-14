import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/food_item.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import 'food_detail_screen.dart';
import 'notifications_screen.dart';

/// Màn hình chính (Home): Header → Tìm kiếm → Chip danh mục → Lưới món ăn.
/// Nhận [onAddToCart] và [onSeeAll] để giao tiếp với MainShell.
class HomeScreen extends StatefulWidget {
  final ValueChanged<FoodItem>? onAddToCart;
  final VoidCallback? onSeeAll;

  const HomeScreen({super.key, this.onAddToCart, this.onSeeAll});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  String _query = '';

  /// Lọc món theo danh mục đang chọn VÀ từ khóa tìm kiếm.
  List<FoodItem> get _visibleFoods {
    final cat = SampleData.categories[_selectedCategory];
    final q = _query.trim().toLowerCase();
    return SampleData.foods.where((f) {
      final matchCat = cat == 'Tất cả' || f.category == cat;
      final matchQuery = q.isEmpty || f.name.toLowerCase().contains(q);
      return matchCat && matchQuery;
    }).toList();
  }

  void _openDetail(FoodItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(
          item: item,
          onAddToCart: widget.onAddToCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(),
                const SizedBox(height: 16),
                SearchField(
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 16),
                _buildCategories(),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Menu hôm nay',
                  onActionTap: widget.onSeeAll,
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          _buildFoodGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  /// Header: lời chào + ngày tháng bên trái, chuông thông báo bên phải.
  Widget _buildHeader() {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chào, Luong!',
                  style: AppTextStyles.greeting
                      .copyWith(color: palette.textPrimary)),
              const SizedBox(height: 6),
              Text('Thứ 6, 12/06/2026',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: palette.textSecondary)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          icon: Icon(Icons.notifications_none,
              color: palette.textPrimary, size: 24),
        ),
      ],
    );
  }

  /// Danh sách chip danh mục cuộn ngang.
  Widget _buildCategories() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: SampleData.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => CategoryChip(
          label: SampleData.categories[index],
          isSelected: index == _selectedCategory,
          onTap: () => setState(() => _selectedCategory = index),
        ),
      ),
    );
  }

  /// Lưới món ăn responsive: 2 cột trên điện thoại, tăng cột trên màn rộng.
  Widget _buildFoodGrid() {
    final foods = _visibleFoods;
    if (foods.isEmpty) return _buildNoResult();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount =
              (constraints.crossAxisExtent / 185).floor().clamp(2, 4);
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
              childAspectRatio: 169 / 210,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => FoodCard(
                item: foods[index],
                onTap: () => _openDetail(foods[index]),
                onAdd: () => widget.onAddToCart?.call(foods[index]),
              ),
              childCount: foods.length,
            ),
          );
        },
      ),
    );
  }

  /// Trạng thái rỗng khi tìm kiếm không có kết quả.
  Widget _buildNoResult() {
    final palette = context.palette;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 56, color: palette.textHint),
            const SizedBox(height: 12),
            Text('Không tìm thấy món phù hợp',
                style: AppTextStyles.body
                    .copyWith(color: palette.textSecondary)),
          ],
        ),
      ),
    );
  }
}
