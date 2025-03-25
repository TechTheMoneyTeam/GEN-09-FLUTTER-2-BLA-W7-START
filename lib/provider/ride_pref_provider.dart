import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;
  bool _isLoading = false;
  bool _hasError = false;

  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> fetchPastPreferences() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _pastPreferences = await repository.getPastPreferences();
      _isLoading = false;
    } catch (error) {
      _isLoading = false;
      _hasError = true;
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
    
    _pastPreferences.removeWhere((pref) => pref == preference);
    _pastPreferences.add(preference);
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}