import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final category = ref.watch(selectedCategoryProvider);
  return firestore.getActiveProductsStream(category: category);
});
