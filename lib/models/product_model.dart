import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/timestamp_converter.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String title,
    required double price,
    required String description,
    required String category,
    @Default('yangi') String condition, // 'yangi' | 'ishlatilgan'
    @Default([]) List<String> images,
    required String region,
    @Default('') String city,
    required String sellerId,
    required String sellerName,
    @Default('') String sellerPhone,
    @TimestampConverter() required DateTime createdAt,
    @Default('active') String status, // 'active' | 'pending' | 'sold'
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}
