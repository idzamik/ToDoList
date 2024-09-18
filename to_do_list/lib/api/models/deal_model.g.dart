// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealModel _$DealModelFromJson(Map<String, dynamic> json) => DealModel(
      deal: (json['deal'] as List<dynamic>)
          .map((e) => DealModelData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DealModelToJson(DealModel instance) => <String, dynamic>{
      'deal': instance.deal,
    };

DealModelData _$DealModelDataFromJson(Map<String, dynamic> json) =>
    DealModelData(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      text: json['text'] as String,
      charts_is_done: json['charts_is_done'] as bool,
    );

Map<String, dynamic> _$DealModelDataToJson(DealModelData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'charts_is_done': instance.charts_is_done,
    };
