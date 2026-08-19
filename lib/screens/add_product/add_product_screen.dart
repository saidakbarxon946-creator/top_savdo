import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  String _selectedCategory = 'electronics';
  String _selectedCondition = 'yangi';
  String _selectedRegion = 'Toshkent shahri';
  bool _isSubmitting = false;

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E\'lon joylash uchun ilovaga kiring (Login qiling).'),
          backgroundColor: Colors.orange,
        ),
      );
      context.push('/login');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final double price = double.tryParse(_priceController.text.replaceAll(' ', '')) ?? 0;

      final newProduct = ProductModel(
        id: '',
        title: _titleController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        condition: _selectedCondition,
        images: _selectedImages.isNotEmpty
            ? [AppConstants.defaultProductImage]
            : [AppConstants.defaultProductImage],
        region: _selectedRegion,
        sellerId: user.uid,
        sellerName: user.displayName ?? 'Foydalanuvchi',
        sellerPhone: user.phoneNumber ?? '',
        createdAt: DateTime.now(),
        status: 'active',
      );

      await _firestoreService.addProduct(newProduct);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E\'lon muvaffaqiyatli joylandi!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('E\'lon joylashda xatolik: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yangi e\'lon joylash'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Upload Section
                Text(
                  'Mahsulot rasmlari',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.4)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, color: AppTheme.primaryColor, size: 30),
                              SizedBox(height: 6),
                              Text('Rasm qo\'shish', style: TextStyle(fontSize: 11, color: AppTheme.primaryColor)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ..._selectedImages.map(
                        (img) => Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: Icon(Icons.image_rounded, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Title Input
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Sarlavha (Nom)',
                    hintText: 'Masalan: iPhone 15 Pro Max 256GB',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Sarlavhani kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategoriya',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: AppConstants.defaultCategories.map((cat) {
                    return DropdownMenuItem(
                      value: cat['id'] as String,
                      child: Text(cat['name'] as String),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Price Input
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Narxi (so\'mda)',
                    hintText: '12 000 000',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Narxni kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Condition Selection with SegmentedButton
                Text(
                  'Holati',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'yangi', label: Text('Yangi')),
                    ButtonSegment(value: 'ishlatilgan', label: Text('Ishlatilgan')),
                  ],
                  selected: {_selectedCondition},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedCondition = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Region Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedRegion,
                  decoration: const InputDecoration(
                    labelText: 'Hudud (Viloyat)',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  items: AppConstants.regions.map((reg) {
                    return DropdownMenuItem(
                      value: reg,
                      child: Text(reg),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedRegion = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Batafsil tavsif',
                    hintText: 'Mahsulot holati, kafolat va qo\'shimcha ma\'lumotlarni yozing...',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Tavsifni kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Submit Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'E\'lonni chop etish',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
