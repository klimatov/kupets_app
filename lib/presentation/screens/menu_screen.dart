import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/categories.dart';
import '../viewmodels/menu_view_model.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuViewModel>();

    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: MenuCategories.filterKeys.map((key) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(MenuCategories.labels[key]!),
                  selected: vm.category == key,
                  onSelected: (_) => vm.setCategory(key),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _buildBody(vm),
        ),
      ],
    );
  }

  Widget _buildBody(MenuViewModel vm) {
    if (vm.loading && vm.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }
    if (vm.items.isEmpty) {
      return const Center(child: Text('Нет позиций в этой категории'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: vm.items.length,
      itemBuilder: (context, index) {
        final item = vm.items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.push('/menu/${item.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: Image.asset(
                    item.imageAsset,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 96,
                      height: 96,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.displayPrice,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        if (item.weight != null)
                          Text(
                            item.weight!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}
