// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      condition: json['condition'] as String? ?? 'yangi',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      region: json['region'] as String,
      city: json['city'] as String? ?? '',
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerPhone: json['sellerPhone'] as String? ?? '',
      year: json['year'] as String? ?? '',
      mileage: json['mileage'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      status: json['status'] as String? ?? 'active',
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'condition': instance.condition,
      'images': instance.images,
      'region': instance.region,
      'city': instance.city,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'sellerPhone': instance.sellerPhone,
      'year': instance.year,
      'mileage': instance.mileage,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'status': instance.status,
    };
