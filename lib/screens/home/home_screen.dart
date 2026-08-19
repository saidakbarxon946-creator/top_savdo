import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_item.dart';
import '../../widgets/carousel_banner.dart';
import '../../providers/product_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storefront_rounded, color: AppTheme.primaryColor, size: 22),
            ),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.newspaper_rounded),
            onPressed: () => context.push('/news'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Search Banner bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF2D3748)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        'TopSavdodan istalgan narsani qidiring...',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Carousel Slider (Checklist Requirement #6)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: CarouselBanner(),
            ),
          ),

          // Horizontal Categories Header & List
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Kategoriyalar',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CategoryItem(
                        title: 'Barchasi',
                        icon: Icons.apps_rounded,
                        color: AppTheme.primaryColor,
                        isSelected: selectedCategory == 'all',
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state = 'all';
                        },
                      ),
                      ...AppConstants.defaultCategories.map((cat) {
                        final id = cat['id'] as String;
                        return CategoryItem(
                          title: cat['name'] as String,
                          icon: cat['icon'] as IconData,
                          color: cat['color'] as Color,
                          isSelected: selectedCategory == id,
                          onTap: () {
                            ref.read(selectedCategoryProvider.notifier).state = id;
                          },
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Section Title: "Yangi e'lonlar"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory == 'all'
                        ? 'Yangi e\'lonlar'
                        : '${_getCategoryName(selectedCategory)} e\'lonlari',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (selectedCategory != 'all')
                    TextButton(
                      onPressed: () {
                        ref.read(selectedCategoryProvider.notifier).state = 'all';
                      },
                      child: const Text('Barchasiga qaytish'),
                    ),
                ],
              ),
            ),
          ),

          // Products Grid View with STRICT Category Filtering
          Builder(
            builder: (context) {
              final allProds = ref.watch(allProductsProvider);

              // STRICT Category Filtering
              final filteredProducts = selectedCategory == 'all'
                  ? allProds
                  : allProds.where((p) => p.category == selectedCategory).toList();

              if (filteredProducts.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Ushbu kategoriyada hali e\'lonlar mavjud emas',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/add-product'),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Birinchi bo\'lib e\'lon joylash'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String id) {
    for (final cat in AppConstants.defaultCategories) {
      if (cat['id'] == id) return cat['name'] as String;
    }
    return 'Saralangan';
  }
}
