import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/api/models/deal_model.dart';


Future<DealModel?> getDataDeals(key) async {
  var prefs = await SharedPreferences.getInstance();
  final getDataDealsInfo = prefs.getString(key);
  if (getDataDealsInfo == null) return DealModel(deal: []);

  return DealModel.fromJson(json.decode(getDataDealsInfo));
}


Future setDataDeals(key, data) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(data));
}