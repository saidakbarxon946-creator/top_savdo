// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportModelImpl _$$ReportModelImplFromJson(Map<String, dynamic> json) =>
    _$ReportModelImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      reportedBy: json['reportedBy'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$ReportModelImplToJson(_$ReportModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'reportedBy': instance.reportedBy,
      'reason': instance.reason,
      'status': instance.status,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
