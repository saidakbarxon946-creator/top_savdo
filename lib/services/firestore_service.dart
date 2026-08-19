import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../core/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch Active Products Stream (ordered by createdAt descending)
  Stream<List<ProductModel>> getActiveProductsStream({String? category, int limit = 20}) {
    Query query = _firestore
        .collection('products')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (category != null && category.isNotEmpty && category != 'all') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    });
  }

  /// Fetch Single Product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists && doc.data() != null) {
        return ProductModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Add new Product
  Future<void> addProduct(ProductModel product) async {
    final docRef = _firestore.collection('products').doc();
    final productWithId = product.copyWith(id: docRef.id);
    await docRef.set(productWithId.toJson());
  }

  /// Get Default Categories List
  List<CategoryModel> getCategories() {
    return AppConstants.defaultCategories
        .map((cat) => CategoryModel(
              id: cat['id'] as String,
              name: cat['name'] as String,
              icon: cat['id'] as String,
            ))
        .toList();
  }
}
