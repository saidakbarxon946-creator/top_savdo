// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      isTrusted: json['isTrusted'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'photoUrl': instance.photoUrl,
      'role': instance.role,
      'rating': instance.rating,
      'isTrusted': instance.isTrusted,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
