import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/api/models/deal_model.dart';


Future<DealModel> getDataDeals(key) async {
  var prefs = await SharedPreferences.getInstance();
  final getDataDealsInfo = prefs.getString(key);
  if (getDataDealsInfo == null) return DealModel(deal: []);

  return DealModel.fromJson(json.decode(getDataDealsInfo));
}


Future setDataDeals(String key, data) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(data));
}


Future deleteDataDeals(key) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
  return true;
}


// ------------------------------------------------------


Future<int> getIdRange(key) async {
  var prefs = await SharedPreferences.getInstance();

  return prefs.getInt(key) ?? 0;
}


Future setIdRange(String key, int data) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, data);
}