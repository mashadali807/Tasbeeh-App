import '../../auth/controller/auth_controller.dart';
import '../models/daily_adhkar_model.dart';

import '../services/daily_adhkar_favourite_service.dart';
import '../services/daily_adhkar_services.dart';
import 'daily_adhkar_repo.dart';

class DailyAdhkarRepositoryImpl implements DailyAdhkarRepository {
  final DailyAdhkarService _adhkarService;
  final DailyAdhkarFavoriteService _favoriteService;
  final AuthController _authController;

  DailyAdhkarRepositoryImpl({
    required DailyAdhkarService adhkarService,
    required DailyAdhkarFavoriteService favoriteService,
    required AuthController authController,
  }) : _adhkarService = adhkarService,
        _favoriteService = favoriteService,
        _authController = authController;

  String get _userId {
    final user = _authController.state.user;
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  @override
  Future<List<DailyAdhkar>> getAdhkar() => _adhkarService.loadAdhkar();

  @override
  Future<Set<String>> getFavorites() => _favoriteService.getFavorites(_userId);

  @override
  Future<void> toggleFavorite(String adhkarId, bool isFavorite) =>
      _favoriteService.toggleFavorite(_userId, adhkarId, isFavorite);

  @override
  Future<void> loadFavoritesFromFirestore() =>
      _favoriteService.loadFavoritesFromFirestore(_userId);
}