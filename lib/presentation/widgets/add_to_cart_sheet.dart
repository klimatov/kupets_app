import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/menu_item.dart';
import '../viewmodels/cart_view_model.dart';

Future<void> showAddToCartSheet(BuildContext context, MenuItem item) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _AddToCartSheet(item: item),
  );
}

class _AddToCartSheet extends StatefulWidget {
  const _AddToCartSheet({required this.item});

  final MenuItem item;

  @override
  State<_AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<_AddToCartSheet> {
  VolumeOption? _selectedVolume;

  @override
  void initState() {
    super.initState();
    if (widget.item.hasVolumes) {
      _selectedVolume = widget.item.volumes!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final price = item.hasVolumes ? _selectedVolume!.price : (item.price ?? 0);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Добавить в заказ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(item.name, style: Theme.of(context).textTheme.titleMedium),
          if (item.hasVolumes) ...[
            const SizedBox(height: 16),
            Text('Объём', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: item.volumes!.map((volume) {
                return ChoiceChip(
                  label: Text('${volume.label} — ${volume.price} ₽'),
                  selected: _selectedVolume == volume,
                  onSelected: (_) => setState(() => _selectedVolume = volume),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Итого: $price ₽',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final cart = context.read<CartViewModel>();
              await cart.addItem(
                item: item,
                volumeLabel: _selectedVolume?.label,
                price: price,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Добавлено в корзину')),
                );
              }
            },
            child: const Text('В корзину'),
          ),
        ],
      ),
    );
  }
}
