import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        path: '/census/:id',
        name: 'census',
        builder: (context, state) {
          final censusId = state.pathParameters['id'];
          return CensusScreen(censusId: censusId);
        },
      ),
    ],
  );
});