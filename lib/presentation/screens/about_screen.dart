import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/bar_info.dart';
import '../../data/repositories/wiki_repository.dart';
import '../widgets/kupets_app_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String? _wikiExtract;
  bool _loadingWiki = true;

  @override
  void initState() {
    super.initState();
    _loadWiki();
  }

  Future<void> _loadWiki() async {
    final wiki = context.read<WikiRepository>();
    final summary = await wiki.getCraftBeerSummary();
    if (mounted) {
      setState(() {
        _wikiExtract = summary?.extract;
        _loadingWiki = false;
      });
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KupetsAppBar(showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/IMG_7825.webp',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            BarInfo.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            BarInfo.slogan,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(BarInfo.history),
          const SizedBox(height: 16),
          _InfoTile(icon: Icons.place, title: 'Адрес', subtitle: BarInfo.address),
          _InfoTile(icon: Icons.phone, title: 'Телефон', subtitle: BarInfo.phone),
          _InfoTile(icon: Icons.schedule, title: 'Часы работы', subtitle: BarInfo.hours),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openUrl(BarInfo.vkUrl),
                icon: const Icon(Icons.public),
                label: const Text('VK'),
              ),
              ElevatedButton.icon(
                onPressed: () => _openUrl(BarInfo.telegramUrl),
                icon: const Icon(Icons.telegram),
                label: const Text('Telegram'),
              ),
              OutlinedButton.icon(
                onPressed: () => _openUrl(BarInfo.mapUrl),
                icon: const Icon(Icons.map),
                label: const Text('На карте'),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(
            'О крафтовом пиве',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (_loadingWiki)
            const Center(child: CircularProgressIndicator())
          else if (_wikiExtract != null)
            Text(_wikiExtract!)
          else
            const Text('Не удалось загрузить статью из Wikipedia'),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
