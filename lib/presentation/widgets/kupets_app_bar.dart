import 'package:flutter/material.dart';

import '../../core/constants/bar_info.dart';

class KupetsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KupetsAppBar({super.key, this.showBack = false});

  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Image.asset(
        'assets/images/logo_word_line.png',
        height: 32,
        errorBuilder: (_, __, ___) => const Text(BarInfo.name),
      ),
      centerTitle: true,
    );
  }
}
