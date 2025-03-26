// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart' show RidePreferencesRepository;
import 'package:week_3_blabla_project/ui/provider/async_value.dart';


class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  final RidePreferencesRepository repository;
  late AsyncValue<List<RidePreference>> pastPreferences;

  RidesPreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time
    // Your code
    _fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;
  void setCurrentPreference(RidePreference pref) {
    // Your code
    if (currentPreference != pref) {
      _currentPreference = pref;

      addPreference(pref);
    }
    notifyListeners();
  }

  void addPreference(RidePreference pref) async {
    if (!pastPreferences.data!.contains(pref)) {
      // remove the past if duplicate place is found
      pastPreferences.data!.remove(pref);
      pastPreferences.data!.add(pref);

      // update the list of past preferences
      await repository.addPreference(pref);
    }
    notifyListeners();
  }

  Future<void> _fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      // 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      // 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
      // 4 Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      pastPreferences.data!.reversed.toList();
}
