import '../models/address.dart';
import '../models/food_item.dart';
import '../models/order.dart';
import '../models/payment_method.dart';
import '../models/review.dart';
import '../models/user.dart';
import 'dao/address_dao.dart';
import 'dao/cart_dao.dart';
import 'dao/favorites_dao.dart';
import 'dao/meal_dao.dart';
import 'dao/notification_dao.dart';
import 'dao/order_dao.dart';
import 'dao/payment_method_dao.dart';
import 'dao/review_dao.dart';
import 'dao/user_dao.dart';

/// Facade duy nhất cho toàn bộ lớp DB - import file này thay vì từng DAO.
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<User?> registerUser({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final existing = await UserDao.instance.findByEmail(email);
    if (existing != null) return null; // email đã tồn tại
    final user = User(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await UserDao.instance.insert(user);
    return user;
  }

  Future<User?> login(String email, String password) async {
    final user = await UserDao.instance.findByEmail(email);
    if (user == null || user.password != password) return null;
    return user;
  }

  Future<User?> getUserById(String id) => UserDao.instance.findById(id);

  Future<void> updateUser(User user) => UserDao.instance.update(user);

  // ── Meals ─────────────────────────────────────────────────────────────────

  Future<void> saveMeal(FoodItem meal) => MealDao.instance.upsert(meal);
  Future<List<FoodItem>> getAllMeals() => MealDao.instance.findAll();
  Future<FoodItem?> getMealById(String id) => MealDao.instance.findById(id);
  Future<List<FoodItem>> getMealsByCategory(String cat) =>
      MealDao.instance.findByCategory(cat);

  // ── Reviews ───────────────────────────────────────────────────────────────

  Future<void> addReview(Review review) => ReviewDao.instance.insert(review);
  Future<List<Review>> getReviews(String mealId) =>
      ReviewDao.instance.findByMeal(mealId);

  // ── Favorites ─────────────────────────────────────────────────────────────

  Future<List<String>> getFavoriteIds(String userId) =>
      FavoritesDao.instance.getMealIds(userId);

  Future<bool> isFavorite(String userId, String mealId) =>
      FavoritesDao.instance.isFavorite(userId, mealId);

  Future<void> toggleFavorite(String userId, String mealId) =>
      FavoritesDao.instance.toggle(userId, mealId);

  Future<void> addFavorite(String userId, String mealId) =>
      FavoritesDao.instance.add(userId, mealId);

  Future<void> removeFavorite(String userId, String mealId) =>
      FavoritesDao.instance.remove(userId, mealId);

  // ── Cart ──────────────────────────────────────────────────────────────────

  Future<List<CartRow>> getCartItems(String userId) =>
      CartDao.instance.getItems(userId);

  Future<void> upsertCartItem(String userId, String mealId, int qty) =>
      CartDao.instance.upsert(userId, mealId, qty);

  Future<void> removeCartItem(String userId, String mealId) =>
      CartDao.instance.removeItem(userId, mealId);

  Future<void> clearCart(String userId) =>
      CartDao.instance.clearCart(userId);

  // ── Orders ────────────────────────────────────────────────────────────────

  Future<void> placeOrder(Order order, List<OrderItem> items) =>
      OrderDao.instance.insertWithItems(order, items);

  Future<List<Order>> getOrderHistory(String userId) =>
      OrderDao.instance.findByUser(userId);

  Future<Order?> getOrderById(String id) => OrderDao.instance.findById(id);

  Future<List<OrderItem>> getOrderItems(String orderId) =>
      OrderDao.instance.getItems(orderId);

  Future<void> updateOrderStatus(String orderId, String status) =>
      OrderDao.instance.updateStatus(orderId, status);

  // ── Addresses ─────────────────────────────────────────────────────────────

  Future<List<Address>> getAddresses(String userId) =>
      AddressDao.instance.findByUser(userId);

  Future<Address?> getDefaultAddress(String userId) =>
      AddressDao.instance.getDefault(userId);

  Future<void> saveAddress(Address address) =>
      AddressDao.instance.insert(address);

  Future<void> updateAddress(Address address) =>
      AddressDao.instance.update(address);

  Future<void> deleteAddress(int id) => AddressDao.instance.delete(id);

  // ── Payment Methods ───────────────────────────────────────────────────────

  Future<List<PaymentMethod>> getPaymentMethods(String userId) =>
      PaymentMethodDao.instance.findByUser(userId);

  Future<void> savePaymentMethod(PaymentMethod method) =>
      PaymentMethodDao.instance.insert(method);

  Future<void> deletePaymentMethod(int id) =>
      PaymentMethodDao.instance.delete(id);

  // ── Notifications ─────────────────────────────────────────────────────────

  Future<List<NotificationRow>> getNotifications(String userId) =>
      NotificationDao.instance.findByUser(userId);

  Future<int> getUnreadCount(String userId) =>
      NotificationDao.instance.unreadCount(userId);

  Future<void> markNotificationRead(int id) =>
      NotificationDao.instance.markRead(id);

  Future<void> markAllNotificationsRead(String userId) =>
      NotificationDao.instance.markAllRead(userId);

  Future<void> pushNotification({
    required String userId,
    required String title,
    required String description,
    String iconLabel = 'notifications',
  }) =>
      NotificationDao.instance.insert(
        userId: userId,
        title: title,
        description: description,
        iconLabel: iconLabel,
      );
}
