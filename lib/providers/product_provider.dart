import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

/// Central List of Demo Sample Products for all categories
List<ProductModel> getSampleProducts() {
  return [
    ProductModel(
      id: 'demo_1',
      title: 'iPhone 15 Pro Max 256GB Natural Titanium',
      price: 13500000,
      description: 'Ideal holatda, 1 oy ishlatilgan. Karobka dokument bor. Batareya 100%.',
      category: 'electronics',
      condition: 'yangi',
      year: '2024',
      images: ['https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80'],
      region: 'Toshkent shahri',
      sellerId: 'seller_1',
      sellerName: 'Javohir',
      sellerPhone: '+998 90 123 45 67',
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'demo_2',
      title: 'Chevrolet Cobalt 2-pozitsiya Yevro 2023',
      price: 142000000,
      description: 'Probeg 15,000 km. Kraska toza. Chexol va polik qo\'yilgan.',
      category: 'vehicles',
      condition: 'ishlatilgan',
      year: '2023',
      mileage: '15 000 km',
      images: ['https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=600&q=80'],
      region: 'Samarqand',
      sellerId: 'seller_2',
      sellerName: 'Sardor',
      sellerPhone: '+998 93 456 78 90',
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'demo_3',
      title: 'BMW X5 M-Sport xDrive 2024',
      price: 980000000,
      description: 'Yangi mashina, probeg 0 km. Avtosalondan chiqqan.',
      category: 'vehicles',
      condition: 'yangi',
      year: '2024',
      mileage: '0 km',
      images: ['https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=600&q=80'],
      region: 'Toshkent shahri',
      sellerId: 'seller_3',
      sellerName: 'Dostonbek',
      sellerPhone: '+998 97 777 00 11',
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'demo_4',
      title: 'MacBook Air M2 8GB / 256GB Space Gray',
      price: 11200000,
      description: 'Holati a\'lo. Sikl zaryad 45 marta. Aybi yo\'q.',
      category: 'electronics',
      condition: 'yangi',
      year: '2023',
      images: ['https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80'],
      region: 'Toshkent shahri',
      sellerId: 'seller_4',
      sellerName: 'Davron',
      sellerPhone: '+998 91 234 56 78',
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'demo_5',
      title: '3 Xonali Kvartira Chilonzor 9-Kvartal',
      price: 780000000,
      description: 'Yevro remont, mebel va maishiy texnikalari bilan qoladi.',
      category: 'real_estate',
      condition: 'ishlatilgan',
      year: '2021',
      images: ['https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=600&q=80'],
      region: 'Toshkent shahri',
      sellerId: 'seller_5',
      sellerName: 'Dilshod',
      sellerPhone: '+998 99 888 77 66',
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'demo_6',
      title: 'Nike Air Jordan 1 Retro High Original (Size 42)',
      price: 950000,
      description: 'Original krossovka, Amerikadan kelgan.',
      category: 'fashion',
      condition: 'yangi',
      year: '2024',
      images: ['https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=600&q=80'],
      region: 'Farg\'ona',
      sellerId: 'seller_6',
      sellerName: 'Bekzod',
      sellerPhone: '+998 94 555 44 33',
      createdAt: DateTime.now(),
    ),
  ];
}

class LocalProductsNotifier extends StateNotifier<List<ProductModel>> {
  LocalProductsNotifier() : super([]);

  void addProduct(ProductModel product) {
    state = [product, ...state];
  }

  void removeProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final localProductsProvider = StateNotifierProvider<LocalProductsNotifier, List<ProductModel>>((ref) {
  return LocalProductsNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({'demo_1', 'demo_3'});

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getActiveProductsStream();
});

final allProductsProvider = Provider<List<ProductModel>>((ref) {
  final local = ref.watch(localProductsProvider);
  final stream = ref.watch(productsStreamProvider).value ?? [];
  final demos = getSampleProducts();

  final Map<String, ProductModel> map = {};
  for (final p in demos) {
    map[p.id] = p;
  }
  for (final p in stream) {
    map[p.id] = p;
  }
  for (final p in local) {
    map[p.id] = p;
  }
  return map.values.toList();
});

