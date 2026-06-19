import '../datasources/menu_asset_datasource.dart';
import '../models/menu_item.dart';
import '../models/promotion.dart';

class MenuRepository {
  MenuRepository(this._dataSource);

  final MenuAssetDataSource _dataSource;
  List<MenuItem>? _cache;

  Future<List<MenuItem>> getAll() async {
    _cache ??= await _dataSource.loadMenu();
    return _cache!;
  }

  Future<MenuItem?> getById(String id) async {
    final items = await getAll();
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<List<MenuItem>> getByCategory(String category) async {
    final items = await getAll();
    if (category == 'all') return items;
    return items.where((item) => item.category == category).toList();
  }
}

class PromotionRepository {
  PromotionRepository(this._dataSource);

  final PromotionAssetDataSource _dataSource;

  Future<List<Promotion>> getAll() => _dataSource.loadPromotions();
}
