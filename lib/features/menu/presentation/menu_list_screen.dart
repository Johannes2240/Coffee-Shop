import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../models/menu_item_model.dart';
import '../providers/menu_provider.dart';

class MenuListScreen extends StatelessWidget {
  const MenuListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (BuildContext context, MenuProvider provider, _) {
        final items = provider.filteredItems;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/form'),
            backgroundColor: AppTheme.kAccent,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: provider.fetchItems,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  _DashboardSummary(provider: provider),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: provider.setSearchQuery,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search the menu',
                      hintText: 'Latte, brownie, croissant...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppConstants.categories.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final category = AppConstants.categories[index];
                        return ChoiceChip(
                          label: Text(category),
                          selected: provider.selectedCategory == category,
                          onSelected: (_) => provider.setCategory(category),
                        );
                      },
                    ),
                  ),
                  if (provider.error != null) ...<Widget>[
                    const SizedBox(height: 16),
                    _InlineError(
                      message: provider.error!,
                      onRetry: provider.fetchItems,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Today\'s menu',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  if (provider.isLoading && provider.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (items.isEmpty)
                    const _EmptyMenuState()
                  else
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            final crossAxisCount = constraints.maxWidth > 900
                                ? 3
                                : constraints.maxWidth > 640
                                ? 2
                                : 1;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.9,
                                  ),
                              itemBuilder: (BuildContext context, int index) {
                                return _MenuCard(item: items[index]);
                              },
                            );
                          },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardSummary extends StatelessWidget {
  const _DashboardSummary({required this.provider});

  final MenuProvider provider;

  @override
  Widget build(BuildContext context) {
    final cards = <({String title, String value, IconData icon})>[
      (
        title: 'Menu Items',
        value: provider.items.length.toString(),
        icon: Icons.coffee,
      ),
      (
        title: 'Available',
        value: provider.availableCount.toString(),
        icon: Icons.check_circle_outline,
      ),
      (
        title: 'Paused',
        value: provider.unavailableCount.toString(),
        icon: Icons.pause_circle_outline,
      ),
      (
        title: 'Value',
        value: '${provider.estimatedRevenue.toStringAsFixed(2)} ETB',
        icon: Icons.payments_outlined,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF6F4E37), Color(0xFFC67C4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Brew board',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'A cleaner cafe menu with sensible food, drink, and pastry items.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (BuildContext context, int index) {
              final card = cards[index];
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(card.icon, color: Colors.white),
                      Text(
                        card.value,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        card.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item});

  final MenuItemModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/detail', extra: item),
      borderRadius: BorderRadius.circular(18),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (item.thumbnail != null && item.thumbnail!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: item.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (BuildContext context, String url, Object error) =>
                              const _ImageFallback(),
                    )
                  else
                    const _ImageFallback(),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          '${item.price.toStringAsFixed(2)} ETB',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item.isAvailable
                            ? Colors.green.withValues(alpha: 0.85)
                            : Colors.red.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          item.isAvailable ? 'Available' : 'Unavailable',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.category,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          item.isAvailable
                              ? 'Fresh and ready to serve'
                              : 'Temporarily paused',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (!item.isSynced)
                        const Icon(Icons.cloud_off, color: Colors.orangeAccent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.kSurface,
      alignment: Alignment.center,
      child: const Icon(Icons.local_cafe, size: 48, color: AppTheme.kAccent),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            const Icon(Icons.warning_amber_rounded, color: AppTheme.kAccent),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyMenuState extends StatelessWidget {
  const _EmptyMenuState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.local_cafe_outlined,
              size: 52,
              color: AppTheme.kAccent,
            ),
            const SizedBox(height: 12),
            Text(
              'No menu items match this filter.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try another category or add a new special for today.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
