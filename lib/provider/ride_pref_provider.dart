import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> _pastPreferences = AsyncValue.loading();
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;
  AsyncValue<List<RidePreference>> get pastPreferences => _pastPreferences;

  Future<void> fetchPastPreferences() async {
    _pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      final preferences = await repository.getPastPreferences();
      _pastPreferences = AsyncValue.success(preferences);
    } catch (error) {
      _pastPreferences = AsyncValue.error(error);
      print('Error fetching past preferences: $error');
    }
    
    notifyListeners();
  }

  void setCurrentPreference(RidePreference pref) async {
    if (_currentPreference != pref) {
      _currentPreference = pref;
      await _addPreference(pref);
      notifyListeners();
    }
  }

  Future<void> _addPreference(RidePreference preference) async {
    await repository.addPreference(preference);
    
    if (_pastPreferences.data != null) {
      final updatedPreferences = List<RidePreference>.from(_pastPreferences.data!)
        ..removeWhere((pref) => pref == preference)
        ..add(preference);
      
      _pastPreferences = AsyncValue.success(updatedPreferences);
    }
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.data?.reversed.toList() ?? [];
}