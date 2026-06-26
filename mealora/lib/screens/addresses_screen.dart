import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../models/address.dart';
import '../state/session_controller.dart';
import '../theme/app_palette.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

/// Quản lý địa chỉ giao hàng: xem danh sách, thêm, đặt mặc định, xóa.
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Address> _addresses = [];
  bool _loading = true;

  String get _userId => SessionController.instance.userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await DatabaseService.instance.getAddresses(_userId);
    if (!mounted) return;
    setState(() {
      _addresses = list;
      _loading = false;
    });
  }

  Future<void> _openForm({Address? existing}) async {
    final labelCtrl = TextEditingController(text: existing?.label ?? '');
    final detailCtrl = TextEditingController(text: existing?.detail ?? '');
    bool isDefault = existing?.isDefault ?? _addresses.isEmpty;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(existing == null ? 'Thêm địa chỉ' : 'Sửa địa chỉ',
                  style: AppTextStyles.subtitle),
              const SizedBox(height: 16),
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(
                    labelText: 'Tên gợi nhớ (VD: Nhà, Công ty)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Địa chỉ đầy đủ'),
              ),
              CheckboxListTile(
                value: isDefault,
                onChanged: (v) =>
                    setSheetState(() => isDefault = v ?? false),
                title: const Text('Đặt làm địa chỉ mặc định'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (labelCtrl.text.trim().isEmpty ||
                        detailCtrl.text.trim().isEmpty) {
                      return;
                    }
                    Navigator.of(sheetContext).pop(true);
                  },
                  child: const Text('Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (saved != true) return;

    final address = Address(
      id: existing?.id,
      userId: _userId,
      label: labelCtrl.text.trim(),
      detail: detailCtrl.text.trim(),
      isDefault: isDefault,
    );

    if (existing == null) {
      await DatabaseService.instance.saveAddress(address);
    } else {
      await DatabaseService.instance.updateAddress(address);
    }
    await _load();
  }

  Future<void> _delete(Address address) async {
    if (address.id == null) return;
    await DatabaseService.instance.deleteAddress(address.id!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: palette.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const AppHeader(title: 'Địa chỉ giao hàng'),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _addresses.isEmpty
                    ? _buildEmpty(context)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _addresses.length,
                        itemBuilder: (context, i) =>
                            _buildCard(context, _addresses[i]),
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
          Icon(Icons.location_off_outlined, size: 56, color: palette.textHint),
          const SizedBox(height: 12),
          Text('Chưa có địa chỉ nào',
              style: AppTextStyles.body.copyWith(color: palette.textSecondary)),
          const SizedBox(height: 4),
          Text('Bấm + để thêm địa chỉ giao hàng',
              style: AppTextStyles.caption.copyWith(color: palette.textHint)),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Address address) {
    final palette = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: address.isDefault
            ? Border.all(color: palette.primary, width: 1.5)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: palette.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label,
                        style: AppTextStyles.semibold15
                            .copyWith(color: palette.textPrimary)),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: palette.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Mặc định',
                            style: AppTextStyles.caption
                                .copyWith(color: palette.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(address.detail,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: palette.textSecondary)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: palette.textHint),
            onSelected: (value) {
              if (value == 'edit') _openForm(existing: address);
              if (value == 'delete') _delete(address);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Sửa')),
              PopupMenuItem(value: 'delete', child: Text('Xóa')),
            ],
          ),
        ],
      ),
    );
  }
}
