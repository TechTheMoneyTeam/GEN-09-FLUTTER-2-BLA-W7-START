import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  Future<void> fetchPastPreferences() async {
    try {
      _pastPreferences = await repository.getPastPreferences();
      notifyListeners();
    } catch (error) {
  
      print('Error fetching past preferences: $error');
    }
  }

  void setCurrentPreference(RidePreference pref) async {
    if (_currentPreference != pref) {
      _currentPreference = pref;
      await _addPreference(pref);
      notifyListeners();
    }
  }

  Future<void> _addPreference(RidePreference preference) async {
    // Approach 2: Call repository and update provider cache
    await repository.addPreference(preference);
    
    _pastPreferences.removeWhere((pref) => pref == preference);
    _pastPreferences.add(preference);
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}