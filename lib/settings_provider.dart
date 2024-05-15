import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSetting>(
        (ref) => UserSettingsNotifier());

class UserSetting {
  String langage;
  String theme;

  UserSetting({this.langage = 'English', this.theme = 'Light'});
}

class UserSettingsNotifier extends StateNotifier<UserSetting> {
  UserSettingsNotifier() : super(UserSetting()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final langage = prefs.getString('langage') ?? 'English';
    final theme = prefs.getString('theme') ?? 'Light';
    state = UserSetting(langage: langage, theme: theme);
  }

  Future<void> updateLangage(String newlangage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langage', newlangage);
    state = UserSetting(langage: newlangage, theme: state.theme);
  }

  Future<void> updateTheme(String newTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', newTheme);
    state = UserSetting(langage: state.langage, theme: newTheme);
  }
}
