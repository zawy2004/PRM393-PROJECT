import 'package:geolocator/geolocator.dart';

/// Kết quả xin quyền vị trí - dùng để hiển thị thông báo phù hợp trên UI.
enum LocationPermissionResult {
  granted,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Kiểm tra dịch vụ định vị + xin quyền nếu cần.
  Future<LocationPermissionResult> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionResult.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.permissionDeniedForever;
    }
    if (permission == LocationPermission.denied) {
      return LocationPermissionResult.permissionDenied;
    }
    return LocationPermissionResult.granted;
  }

  /// Lấy vị trí hiện tại của thiết bị. Gọi [ensurePermission] trước.
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
