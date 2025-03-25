import 'package:flutter/foundation.dart';
import '../../model/ride/ride_pref.dart';
import '../../data/repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? currentPreference;
  AsyncValue<List<RidePreference>> pastPreferences = AsyncValue.loading();
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      final preferences = await repository.getPastPreferences();
      pastPreferences = preferences.isEmpty 
          ? AsyncValue.empty() 
          : AsyncValue.success(preferences);
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    
    notifyListeners();
  }

  Future<void> setCurrentPreference(RidePreference preference) async {
    currentPreference = preference;
    
    try {
      await repository.addPreference(preference);
      
      if (pastPreferences.state == AsyncValueState.success) {
        final updatedPreferences = List<RidePreference>.from(pastPreferences.data!)
          ..removeWhere((pref) => pref == preference)
          ..add(preference);
        
        pastPreferences = updatedPreferences.isEmpty 
            ? AsyncValue.empty() 
            : AsyncValue.success(updatedPreferences);
      } else {
        pastPreferences = AsyncValue.success([preference]);
      }
    } catch (error) {
      pastPreferences = AsyncValue.error(error); 
    }
    
    notifyListeners();
  }

  List<RidePreference> get preferencesHistory {
    return pastPreferences.state == AsyncValueState.success 
        ? (pastPreferences.data?.reversed.toList() ?? []) 
        : [];
  }
}