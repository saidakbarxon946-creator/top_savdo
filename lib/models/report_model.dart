import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/timestamp_converter.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    required String id,
    required String productId,
    required String reportedBy,
    required String reason,
    @Default('pending') String status, // 'pending' | 'reviewed' | 'resolved'
    @TimestampConverter() required DateTime createdAt,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);
}
