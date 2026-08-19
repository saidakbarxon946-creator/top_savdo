import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/product_provider.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool? isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite,
  });

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} so\'m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageUrl = product.images.isNotEmpty
        ? product.images.first
        : AppConstants.defaultProductImage;

    final favoritesState = ref.watch(favoritesProvider);
    final bool favorited = isFavorite ?? favoritesState.contains(product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with Favorite button
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Condition Tag (Yangi / Ishlatilgan)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.condition == 'yangi' ? 'Yangi' : 'Ishlatilgan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        if (onFavoriteTap != null) {
                          onFavoriteTap!();
                        } else {
                          ref.read(favoritesProvider.notifier).toggleFavorite(product.id);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          favorited ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: favorited ? Colors.redAccent : Colors.grey[600],
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Info
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatPrice(product.price),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.region,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
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

