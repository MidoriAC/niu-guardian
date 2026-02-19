import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/census/presentation/screens/census_screen.dart';
import '../../features/census/presentation/screens/home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/census/:id',
        name: 'census',
        builder: (context, state) {
          final censusId = state.pathParameters['id'];
          return CensusScreen(censusId: censusId);
        },
      ),
    ],
    redirect: (context, state) {
      final didShowOnboarding = ref.read(onboardingProvider);
      if (!didShowOnboarding && state.fullPath != '/onboarding') {
         return '/onboarding';
      }
      return null;
    },
  );
});