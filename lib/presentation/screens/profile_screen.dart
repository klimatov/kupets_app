import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_view_model.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().refresh();
    });
  }

  Future<void> _pickAvatar(ProfileViewModel vm) async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      await vm.setAvatar(file.path);
    }
  }

  Future<void> _checkout(ProfileViewModel vm) async {
    if (vm.cartLines.isEmpty) return;
    await vm.checkout();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заказ оформлен')),
      );
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выйти?'),
        content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final profileVm = context.read<ProfileViewModel>();
      final authVm = context.read<AuthViewModel>();
      await profileVm.signOut();
      await authVm.signOut();
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CartViewModel>();
    final vm = context.watch<ProfileViewModel>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: GestureDetector(
            onTap: () => _pickAvatar(vm),
            child: CircleAvatar(
              radius: 48,
              backgroundImage: vm.avatarPath != null
                  ? FileImage(File(vm.avatarPath!))
                  : null,
              child: vm.avatarPath == null
                  ? const Icon(Icons.person, size: 48)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            vm.email ?? 'Гость',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => _pickAvatar(vm),
            icon: const Icon(Icons.photo_camera),
            label: const Text('Сменить аватар'),
          ),
        ),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('О баре'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/about'),
        ),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Корзина', style: Theme.of(context).textTheme.titleLarge),
            if (vm.cartLines.isNotEmpty)
              TextButton(
                onPressed: vm.clearCart,
                child: const Text('Очистить'),
              ),
          ],
        ),
        if (vm.cartLines.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Корзина пуста'),
          )
        else ...[
          ...vm.cartLines.asMap().entries.map((entry) {
            final line = entry.value;
            return Card(
              child: ListTile(
                title: Text(line.name),
                subtitle: Text('${line.price} ₽ × ${line.quantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => vm.removeFromCart(entry.key),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            'Итого: ${vm.cartTotal} ₽',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _checkout(vm),
            child: const Text('Оформить заказ'),
          ),
        ],
        const Divider(height: 32),
        Text('История заказов', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (vm.history.isEmpty)
          const Text('Пока нет заказов')
        else
          ...vm.history.map(
            (order) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  '${order.createdAt.day}.${order.createdAt.month}.${order.createdAt.year}',
                ),
                subtitle: Text(
                  order.lines.map((l) => l.name).join(', '),
                ),
                trailing: Text('${order.total} ₽'),
              ),
            ),
          ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _signOut,
          icon: const Icon(Icons.logout),
          label: const Text('Выйти'),
        ),
      ],
    );
  }
}
