import 'package:flutter/material.dart';
import '../model/ride/ride_pref.dart'; // Adjust path to your RidePreference model
import '../repository/ride_preferences_repository.dart'; // Adjust path to your repository

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
     final loadedPreferences = repository.getPastPreferences();
    _pastPreferences = loadedPreferences.toSet().toList(); // Remove duplicates using Set
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    // Step 1: Process only if the new preference is not equal to the current one
    if (_currentPreference != pref) {
      // Step 2: Update the current preference
      _currentPreference = pref;

      // Step 3: Update the history (no duplicates)
      _addPreference(pref);

      // Step 4: Notify listeners (widgets) of the change
      notifyListeners();
    }
  }

  void _addPreference(RidePreference preference) {
    // Add to past preferences only if it’s not already present (avoid duplicates)
    if (!_pastPreferences.contains(preference)) {
      _pastPreferences.add(preference);
      // Persist the preference to the repository
      repository.addPreference(preference);
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory => _pastPreferences.reversed.toList();
}