import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import '../../dto/ride_pref_dto.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<void> addPreference(RidePreference pref) async {
    List<RidePreference> currentPreference = await getPastPreferences();
    final prefs = await SharedPreferences.getInstance();
    currentPreference.add(pref);

    // Save the new list as a string list
    await prefs.setStringList(
      _preferencesKey,
      currentPreference
          .map((pref) => jsonEncode(RidePrefDto.toJson(pref)))
          .toList(),
    );
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
// Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
// Get the string list form the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
// Convert the string list to a list of RidePreferences – Using map()
    return prefsList
        .map((json) => RidePrefDto.fromJson(jsonDecode(json)))
        .toList();
  }
}
