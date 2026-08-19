import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_item.dart';
import '../../widgets/carousel_banner.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(productsStreamProvider);

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
                    'Yangi e\'lonlar',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Barchasini ko\'rish',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Products Grid View
          productsAsync.when(
            data: (products) {
              final displayProducts = products.isEmpty
                  ? _getSampleProducts()
                  : products;

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
                      final product = displayProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                        onFavoriteTap: () {},
                      );
                    },
                    childCount: displayProducts.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Xatolik yuz berdi: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Demo Sample Products for initial display
  List<ProductModel> _getSampleProducts() {
    return [
      ProductModel(
        id: 'demo_1',
        title: 'iPhone 15 Pro Max 256GB Natural Titanium',
        price: 13500000,
        description: 'Ideal holatda, 1 oy ishlatilgan. Karobka dokument bor.',
        category: 'electronics',
        condition: 'yangi',
        images: ['https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80'],
        region: 'Toshkent shahri',
        sellerId: 'seller_1',
        sellerName: 'Javohir',
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'demo_2',
        title: 'Chevrolet Cobalt 2-pozitsiya Yevro 2023',
        price: 142000000,
        description: 'Probeg 15,000 km. Kraska toza. Chexol va polik qo\'yilgan.',
        category: 'vehicles',
        condition: 'ishlatilgan',
        images: ['https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=600&q=80'],
        region: 'Samarqand',
        sellerId: 'seller_2',
        sellerName: 'Sardor',
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'demo_3',
        title: 'MacBook Air M2 8GB / 256GB Space Gray',
        price: 11200000,
        description: 'Holati a\'lo. Sikl zaryad 45 marta. Aybi yo\'q.',
        category: 'electronics',
        condition: 'yangi',
        images: ['https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80'],
        region: 'Toshkent shahri',
        sellerId: 'seller_3',
        sellerName: 'Davron',
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'demo_4',
        title: 'Nike Air Jordan 1 Retro High Original (Size 42)',
        price: 950000,
        description: 'Original krossovka, Amerikadan kelgan.',
        category: 'fashion',
        condition: 'yangi',
        images: ['https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=600&q=80'],
        region: 'Farg\'ona',
        sellerId: 'seller_4',
        sellerName: 'Bekzod',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
