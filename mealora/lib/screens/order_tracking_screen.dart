import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

/// Một bước trong tiến trình giao hàng.
class _TrackStep {
  final String label;
  final String? time;
  const _TrackStep(this.label, [this.time]);
}

/// Vị trí quán (bếp Mealora) - cố định, dùng làm điểm xuất phát trên bản đồ.
/// (Tọa độ minh họa khu vực Q.5, TP.HCM khớp với địa chỉ mẫu trong app.)
const LatLng _kRestaurantLocation = LatLng(10.7546, 106.6817);

/// Màn hình theo dõi đơn hàng: mã đơn, bản đồ thật (quán -> vị trí bản thân),
/// tiến trình các bước giao hàng và thanh liên hệ shipper.
class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const List<_TrackStep> _steps = [
    _TrackStep('Đã xác nhận', '11:02'),
    _TrackStep('Đang chuẩn bị', '11:10'),
    _TrackStep('Đang giao hàng', '11:25'),
    _TrackStep('Sắp đến nơi'),
    _TrackStep('Đã giao'),
  ];

  // Bước hiện tại (các bước <= chỉ số này coi như đã hoàn thành/đang chạy).
  static const int _currentStep = 2;

  GoogleMapController? _mapController;
  LatLng? _myLocation;
  LocationPermissionResult? _permissionResult;
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadMyLocation();
  }

  Future<void> _loadMyLocation() async {
    final result = await LocationService.instance.ensurePermission();
    if (!mounted) return;

    if (result != LocationPermissionResult.granted) {
      setState(() {
        _permissionResult = result;
        _loadingLocation = false;
      });
      return;
    }

    try {
      final position = await LocationService.instance.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _myLocation = LatLng(position.latitude, position.longitude);
        _permissionResult = result;
        _loadingLocation = false;
      });
      _fitBounds();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _permissionResult = result;
        _loadingLocation = false;
      });
    }
  }

  void _fitBounds() {
    final me = _myLocation;
    final controller = _mapController;
    if (me == null || controller == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        me.latitude < _kRestaurantLocation.latitude
            ? me.latitude
            : _kRestaurantLocation.latitude,
        me.longitude < _kRestaurantLocation.longitude
            ? me.longitude
            : _kRestaurantLocation.longitude,
      ),
      northeast: LatLng(
        me.latitude > _kRestaurantLocation.latitude
            ? me.latitude
            : _kRestaurantLocation.latitude,
        me.longitude > _kRestaurantLocation.longitude
            ? me.longitude
            : _kRestaurantLocation.longitude,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          const AppHeader(title: 'Theo dõi đơn'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                _buildOrderCard(context),
                const SizedBox(height: 16),
                _buildMap(context),
                const SizedBox(height: 16),
                _buildSteps(context),
              ],
            ),
          ),
          _buildContactBar(context),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đơn hàng #MP2026061201',
              style: AppTextStyles.semibold15
                  .copyWith(color: palette.textPrimary)),
          const SizedBox(height: 4),
          Text('Đang giao hàng',
              style:
                  AppTextStyles.bodySmall.copyWith(color: palette.primary)),
        ],
      ),
    );
  }

  /// Bản đồ Google Maps thật: marker quán + marker vị trí bản thân + đường
  /// thẳng nối 2 điểm. Hiển thị trạng thái xin quyền/lỗi nếu chưa có vị trí.
  Widget _buildMap(BuildContext context) {
    final palette = context.palette;

    if (_loadingLocation) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_permissionResult != LocationPermissionResult.granted ||
        _myLocation == null) {
      return _buildLocationIssue(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 220,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _myLocation ?? _kRestaurantLocation,
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('restaurant'),
              position: _kRestaurantLocation,
              infoWindow: const InfoWindow(title: 'Quán Mealora'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
            ),
            Marker(
              markerId: const MarkerId('me'),
              position: _myLocation!,
              infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [_kRestaurantLocation, _myLocation!],
              color: palette.primary,
              width: 4,
            ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            _mapController = controller;
            _fitBounds();
          },
        ),
      ),
    );
  }

  /// Hiển thị khi chưa có quyền vị trí/dịch vụ định vị tắt, kèm nút khắc phục.
  Widget _buildLocationIssue(BuildContext context) {
    final palette = context.palette;
    String message;
    String actionLabel;
    VoidCallback action;

    switch (_permissionResult) {
      case LocationPermissionResult.serviceDisabled:
        message = 'Vui lòng bật định vị (GPS) để xem vị trí của bạn trên bản đồ.';
        actionLabel = 'Mở cài đặt định vị';
        action = () => Geolocator.openLocationSettings();
        break;
      case LocationPermissionResult.permissionDeniedForever:
        message = 'Ứng dụng cần quyền vị trí để hiển thị bản đồ theo dõi đơn.';
        actionLabel = 'Mở cài đặt ứng dụng';
        action = () => Geolocator.openAppSettings();
        break;
      default:
        message = 'Cần quyền vị trí để hiển thị bản đồ theo dõi đơn.';
        actionLabel = 'Thử lại';
        action = () {
          setState(() => _loadingLocation = true);
          _loadMyLocation();
        };
    }

    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 36, color: palette.textHint),
          const SizedBox(height: 10),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: palette.textHint)),
          const SizedBox(height: 14),
          TextButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  /// Danh sách các bước giao hàng dạng timeline dọc.
  Widget _buildSteps(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: List.generate(_steps.length, (index) {
          final step = _steps[index];
          final done = index <= _currentStep;
          final isLast = index == _steps.length - 1;
          return _buildStepRow(context, step, done, isLast);
        }),
      ),
    );
  }

  Widget _buildStepRow(
      BuildContext context, _TrackStep step, bool done, bool isLast) {
    final palette = context.palette;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột chấm tròn + đường nối.
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: done ? palette.primary : palette.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done ? palette.primary : palette.border,
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? palette.primary : palette.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Nhãn + thời gian.
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step.label,
                    style: AppTextStyles.semibold14.copyWith(
                      color: done ? palette.textPrimary : palette.textHint,
                    ),
                  ),
                  if (step.time != null)
                    Text(step.time!,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: palette.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Thanh liên hệ shipper với nút gọi.
  Widget _buildContactBar(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: palette.surfaceVariant,
              child: Icon(Icons.delivery_dining, color: palette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Anh Minh',
                      style: AppTextStyles.semibold14
                          .copyWith(color: palette.textPrimary)),
                  Text('Shipper · 5 sao',
                      style: AppTextStyles.caption
                          .copyWith(color: palette.textSecondary)),
                ],
              ),
            ),
            // Nút gọi.
            Container(
              width: 48,
              height: 40,
              decoration: BoxDecoration(
                color: palette.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
