// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userName: json['userName'] as String,
      text: json['text'] as String,
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'userName': instance.userName,
      'text': instance.text,
      'rating': instance.rating,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
