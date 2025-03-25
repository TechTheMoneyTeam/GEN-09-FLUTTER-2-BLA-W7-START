import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreferrence(RidePreference pref) {
    if (_currentPreference != pref) {
      _currentPreference = pref;

      _addPreference(pref);

      notifyListeners();
    }
  }

  void _addPreference(RidePreference preference) {
    _pastPreferences.removeWhere((pref) => pref == preference);

    _pastPreferences.add(preference);
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
