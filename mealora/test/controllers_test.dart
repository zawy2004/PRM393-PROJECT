// Unit test cho logic giỏ hàng & yêu thích.

import 'package:flutter_test/flutter_test.dart';
import 'package:mealora/data/sample_data.dart';
import 'package:mealora/state/cart_controller.dart';
import 'package:mealora/state/favorites_controller.dart';

void main() {
  group('CartController', () {
    final cart = CartController.instance;

    setUp(cart.clear);

    test('add gộp số lượng khi trùng món', () {
      final food = SampleData.foods.first;
      cart.add(food);
      cart.add(food);
      expect(cart.lines.length, 1);
      expect(cart.itemCount, 2);
      expect(cart.subtotal, food.price * 2);
    });

    test('giảm số lượng về 0 sẽ xóa dòng', () {
      final food = SampleData.foods.first;
      cart.add(food);
      cart.changeQuantity(cart.lines.first, -1);
      expect(cart.isEmpty, true);
    });
  });

  group('FavoritesController', () {
    final fav = FavoritesController.instance;

    test('toggle thêm/bỏ yêu thích', () {
      const id = 'f5';
      final before = fav.isFavorite(id);
      fav.toggle(id);
      expect(fav.isFavorite(id), !before);
      fav.toggle(id); // toggle lại về trạng thái ban đầu.
      expect(fav.isFavorite(id), before);
    });

    test('favorites trả về đúng các món theo id', () {
      for (final f in fav.favorites) {
        expect(fav.isFavorite(f.id), true);
      }
    });
  });
}
