import '../datasources/local_storage.dart';
import '../models/order_line.dart';

class CartRepository {
  CartRepository(this._local);

  final CartLocalDataSource _local;

  List<OrderLine> get lines => _local.getCartLines();

  int get total => lines.fold(0, (sum, line) => sum + line.total);

  Future<void> addLine(OrderLine line) async {
    final current = List<OrderLine>.from(lines)..add(line);
    await _local.saveCartLines(current);
  }

  Future<void> removeAt(int index) async {
    final current = List<OrderLine>.from(lines)..removeAt(index);
    await _local.saveCartLines(current);
  }

  Future<void> clear() async {
    await _local.saveCartLines([]);
  }

  Future<void> checkout() async {
    if (lines.isEmpty) return;
    final history = List<OrderHistoryEntry>.from(_local.getOrderHistory())
      ..insert(
        0,
        OrderHistoryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          lines: List<OrderLine>.from(lines),
        ),
      );
    await _local.saveOrderHistory(history);
    await clear();
  }

  List<OrderHistoryEntry> get history => _local.getOrderHistory();
}

class ProfileRepository {
  ProfileRepository(this._local);

  final ProfileLocalDataSource _local;

  String? get avatarPath => _local.avatarPath;

  Future<void> setAvatarPath(String? path) => _local.setAvatarPath(path);
}
