// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      productId: json['productId'] as String,
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: const TimestampConverter().fromJson(
        json['lastMessageTime'],
      ),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'productId': instance.productId,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': const TimestampConverter().toJson(
        instance.lastMessageTime,
      ),
    };
