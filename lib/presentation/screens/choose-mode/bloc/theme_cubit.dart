import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system); // Default to system theme

  // Update the theme
  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  // Deserialize from storage
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // Convert string back to ThemeMode
    switch (json['themeMode']) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system; // Default to system theme if no match
    }
  }

  // Serialize to storage
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Convert ThemeMode to string for storage
    return {'themeMode': state.toString()};
  }
}
