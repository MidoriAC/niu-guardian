import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false);

  static const String _onboardingKey = 'didShowOnboarding';

  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final didShow = prefs.getBool(_onboardingKey) ?? false;
    state = didShow;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    state = true;
  }
}
