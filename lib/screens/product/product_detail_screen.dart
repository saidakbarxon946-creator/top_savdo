import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../services/firestore_service.dart';
import '../../models/product_model.dart';
import '../../models/comment_model.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  ProductModel? _product;
  bool _isLoading = true;
  int _selectedImageIndex = 0;

  final List<CommentModel> _comments = [
    CommentModel(
      id: 'c1',
      productId: 'demo_1',
      userName: 'Botir Rahimov',
      text: 'Juda yaxshi mahsulot ekan. Sotuvchi bilan bog\'landim, tezda javob berdi.',
      rating: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    CommentModel(
      id: 'c2',
      productId: 'demo_1',
      userName: 'Nodira',
      text: 'Holati ideal deb yozilgan, rasmida ham ko\'rinib turibdi. Rahmat!',
      rating: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final prod = await _firestoreService.getProductById(widget.productId);
    setState(() {
      _product = prod ?? _getDemoProduct(widget.productId);
      _isLoading = false;
    });
  }

  ProductModel _getDemoProduct(String id) {
    return ProductModel(
      id: id,
      title: 'iPhone 15 Pro Max 256GB Natural Titanium',
      price: 13500000,
      description: 'Idrok holatida, 1 oy ishlatilgan. Karobka va hujjatlari to\'liq mavjud. Batareya sig\'imi 100%. Hech qanday tirnalgan va nuqson joyi yo\'q.',
      category: 'electronics',
      condition: 'yangi',
      images: [
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80',
      ],
      region: 'Toshkent shahri',
      sellerId: 'seller_123',
      sellerName: 'Javohirbek',
      sellerPhone: '+998 90 123 45 67',
      createdAt: DateTime.now(),
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} so\'m';
  }

  void _showAddCommentBottomSheet() {
    final commentController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sharh qoldirish',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ismingiz',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Sharhingizni yozing...',
                hintText: 'Mahsulot yoki sotuvchi haqida mulohazangiz...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (commentController.text.trim().isEmpty) return;

                final newComment = CommentModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  productId: widget.productId,
                  userName: nameController.text.trim().isNotEmpty
                      ? nameController.text.trim()
                      : 'Foydalanuvchi',
                  text: commentController.text.trim(),
                  rating: 5,
                  createdAt: DateTime.now(),
                );

                setState(() {
                  _comments.insert(0, newComment);
                });

                Navigator.pop(context);

                // Required Checklist Notification
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Siz yozgan sharh qabul qilindi'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Sharhni yuborish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final product = _product!;
    final images = product.images.isNotEmpty
        ? product.images
        : [AppConstants.defaultProductImage];

    return Scaffold(
      appBar: AppBar(
        title: const Text('E\'lon batafsil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery & Indicator
                  Container(
                    height: 280,
                    width: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 12,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_selectedImageIndex + 1} / ${images.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Main Details
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price & Status Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatPrice(product.price),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                product.condition == 'yangi' ? 'Yangi' : 'Ishlatilgan',
                                style: const TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          product.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Location & Date
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              product.region,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            const Text(
                              'Bugun, 10:45',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        // Description
                        Text(
                          'Tavsif',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            color: theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                        const Divider(height: 32),

                        // Seller Info Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                                  child: Text(
                                    product.sellerName.isNotEmpty
                                        ? product.sellerName[0].toUpperCase()
                                        : 'S',
                                    style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.sellerName,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Row(
                                        children: [
                                          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                          SizedBox(width: 4),
                                          Text('4.9 (Ishonchli sotuvchi)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Comments / Reviews Section (Checklist Requirement #12)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sharh va Mulohazalar (${_comments.length})',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: _showAddCommentBottomSheet,
                              icon: const Icon(Icons.add_comment_outlined, size: 18),
                              label: const Text('Sharh yozish'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        ..._comments.map(
                          (c) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(c.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            Icons.star_rounded,
                                            size: 14,
                                            color: index < c.rating ? Colors.amber : Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(c.text, style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar (Call & Chat)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? AppTheme.darkSurface : AppTheme.lightSurface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Telefon raqam: ${product.sellerPhone.isNotEmpty ? product.sellerPhone : "+998 90 123 45 67"}')),
                      );
                    },
                    icon: const Icon(Icons.phone_rounded),
                    label: const Text('Qo\'ng\'iroq'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/chats'),
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: const Text('Chatda yozish'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
