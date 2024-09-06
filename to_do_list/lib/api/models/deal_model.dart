
import 'package:json_annotation/json_annotation.dart';

part 'deal_model.g.dart';

@JsonSerializable()
class DealModel {
  final List<DealModelData>? deal;

  DealModel({required this.deal});


  factory DealModel.fromJson(Map<String, dynamic> json) =>
      _$DealModelFromJson(json);
  Map<String, dynamic> toJson() => _$DealModelToJson(this);
}


@JsonSerializable()
class DealModelData {
  final int id;
  final String title;
  final String text;
  final List<dynamic> charts;

  DealModelData({
    required this.id, 
    required this.title, 
    required this.text, 
    required this.charts, 
  });


  factory DealModelData.fromJson(Map<String, dynamic> json) =>
      _$DealModelDataFromJson(json);
  Map<String, dynamic> toJson() => _$DealModelDataToJson(this);
}


// [
//   {
//     'id': 12,
//     'title': 'sdtbertbe',
//     'text': 'sldnfboiwentubeortbne',
//     'charts': []
//   },
//   {
//     'id': 32,
//     'title': '1jewtbioeoit',
//     'text': 'ipetpib siptbiopstiobosiodfgio bsdio '
//     'charts': []
//   }
// ]