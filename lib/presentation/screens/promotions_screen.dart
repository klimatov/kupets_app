import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/promotions_view_model.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromotionsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PromotionsViewModel>();

    if (vm.loading && vm.promotions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: vm.load,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            'Акции бара',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...vm.promotions.map(
            (promo) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.local_offer),
                title: Text(promo.title),
                subtitle: Text(promo.description),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Гастро-идея дня',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (vm.meal != null)
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vm.meal!.thumbnail.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        vm.meal!.thumbnail,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.meal!.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (vm.meal!.area.isNotEmpty)
                          Text('Кухня: ${vm.meal!.area}'),
                        const SizedBox(height: 8),
                        Text(
                          vm.meal!.instructions.length > 200
                              ? '${vm.meal!.instructions.substring(0, 200)}...'
                              : vm.meal!.instructions,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (vm.mealError != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(vm.mealError!),
              ),
            ),
        ],
      ),
    );
  }
}
