import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/food_item.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
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
  static const int _pageSize = 8;

  int _selectedCategory = 0;
  String _query = '';
  int _currentPage = 0;

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

  int _totalPages(int itemCount) => (itemCount / _pageSize).ceil();

  /// Cắt danh sách đã lọc theo trang hiện tại.
  List<FoodItem> _pagedFoods(List<FoodItem> source) {
    final start = _currentPage * _pageSize;
    if (start >= source.length) return const [];
    final end = (start + _pageSize).clamp(0, source.length);
    return source.sublist(start, end);
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
                  onChanged: (v) => setState(() {
                    _query = v;
                    _currentPage = 0;
                  }),
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
          SliverToBoxAdapter(child: _buildPagination()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  /// Header: lời chào (tên người dùng thật) + ngày hiện tại bên trái,
  /// chuông thông báo bên phải.
  Widget _buildHeader() {
    final palette = context.palette;
    final fullName = SessionController.instance.currentUser?.fullName;
    final firstName =
        (fullName == null || fullName.isEmpty) ? 'bạn' : fullName.split(' ').last;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chào, $firstName!',
                  style: AppTextStyles.greeting
                      .copyWith(color: palette.textPrimary)),
              const SizedBox(height: 6),
              Text(Formatters.weekdayDate(DateTime.now()),
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
          onTap: () => setState(() {
            _selectedCategory = index;
            _currentPage = 0;
          }),
        ),
      ),
    );
  }

  /// Lưới món ăn responsive: 2 cột trên điện thoại, tăng cột trên màn rộng.
  /// Chỉ hiển thị các món của trang hiện tại (phân trang ở [_buildPagination]).
  Widget _buildFoodGrid() {
    final all = _visibleFoods;
    if (all.isEmpty) return _buildNoResult();
    final foods = _pagedFoods(all);
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

  /// Thanh điều hướng trang: nút Trước/Sau + số trang hiện tại.
  /// Ẩn hoàn toàn khi danh sách (sau khi lọc) chỉ vừa 1 trang.
  Widget _buildPagination() {
    final total = _totalPages(_visibleFoods.length);
    if (total <= 1) return const SizedBox.shrink();
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage -= 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            color: palette.textPrimary,
            disabledColor: palette.textHint,
          ),
          Text('Trang ${_currentPage + 1} / $total',
              style: AppTextStyles.bodySmall
                  .copyWith(color: palette.textSecondary)),
          IconButton(
            onPressed: _currentPage < total - 1
                ? () => setState(() => _currentPage += 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: palette.textPrimary,
            disabledColor: palette.textHint,
          ),
        ],
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
