import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favIds = ref.watch(favoritesProvider);
    final allProds = ref.watch(allProductsProvider);

    final favProducts = allProds.where((p) => favIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saralangan e\'lonlar'),
      ),
      body: favProducts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_outline_rounded,
                      size: 72,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Saralangan e\'lonlar mavjud emas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'O\'zingizga yoqqan e me\'lonlarni saqlab qo\'yish uchun yurakcha belgisini bosing',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('E\'lonlarni ko\'rish'),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: favProducts.length,
              itemBuilder: (context, index) {
                final product = favProducts[index];
                return ProductCard(
                  product: product,
                  isFavorite: true,
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
    );
  }
}

