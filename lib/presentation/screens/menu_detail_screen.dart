import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/menu_item.dart';
import '../../data/repositories/menu_repository.dart';
import '../widgets/add_to_cart_sheet.dart';
import '../widgets/kupets_app_bar.dart';

class MenuDetailScreen extends StatefulWidget {
  const MenuDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late Future<MenuItem?> _itemFuture;

  @override
  void initState() {
    super.initState();
    _itemFuture = context.read<MenuRepository>().getById(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MenuItem?>(
      future: _itemFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            appBar: KupetsAppBar(showBack: true),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final menuItem = snapshot.data;
        if (menuItem == null) {
          return const Scaffold(
            appBar: KupetsAppBar(showBack: true),
            body: Center(child: Text('Позиция не найдена')),
          );
        }

        return Scaffold(
          appBar: const KupetsAppBar(showBack: true),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  menuItem.imageAsset,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuItem.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        menuItem.displayPrice,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      if (menuItem.weight != null) ...[
                        const SizedBox(height: 4),
                        Text('Вес: ${menuItem.weight}'),
                      ],
                      if (menuItem.abv != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Алк.: ${menuItem.abv}%${menuItem.ibu != null ? ', IBU ${menuItem.ibu}' : ''}',
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(menuItem.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showAddToCartSheet(context, menuItem),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('В заказ'),
          ),
        );
      },
    );
  }
}
