import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/product_card.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedRegion = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _getFilteredProducts(List<ProductModel> allProducts) {
    return allProducts.where((p) {
      final matchesQuery = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == 'all' || p.category == _selectedCategory;
      final matchesRegion = _selectedRegion == 'all' || p.region == _selectedRegion;
      return matchesQuery && matchesCat && matchesRegion;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allProducts = ref.watch(allProductsProvider);
    final results = _getFilteredProducts(allProducts);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Qidirish...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter options bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.brightness == Brightness.dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('Barcha kategoriyalar')),
                        ...AppConstants.defaultCategories.map((c) => DropdownMenuItem(
                              value: c['id'] as String,
                              child: Text(c['name'] as String),
                            )),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRegion,
                      isExpanded: true,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('Barcha viloyatlar')),
                        ...AppConstants.regions.map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r),
                            )),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRegion = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'E\'lonlar topilmadi',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text('Qidiruv so\'zini yoki filtrlarni o\'zgartirib ko\'ring'),
                      ],
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
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final product = results[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
