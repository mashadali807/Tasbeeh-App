import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/dhikr_library/models/dhikr_model.dart';
import 'package:tasbeeh/features/dhikr_library/services/dhikr_services.dart';
import 'package:tasbeeh/features/dhikr_library/services/favourite_service.dart';

import 'dhikr_repository.dart';

class DhikrRepositoryImpl implements DhikrRepository {
  final DhikrService _dhikrService;
  final FavoriteService _favoriteService;
  final AuthController _authController;

  DhikrRepositoryImpl({
    required DhikrService dhikrService,
    required FavoriteService favoriteService,
    required AuthController authController,
  }) : _dhikrService = dhikrService,
       _favoriteService = favoriteService,
       _authController = authController;

  String get _userId => _authController.state.user!.id;

  @override
  Future<List<Dhikr>> getDhikrList() => _dhikrService.loadDhikrList();

  @override
  Future<Set<String>> getFavorites() => _favoriteService.getFavorites(_userId);

  @override
  Future<void> toggleFavorite(String dhikrId, bool isFavorite) =>
      _favoriteService.toggleFavorite(_userId, dhikrId, isFavorite);

  @override
  Future<void> loadFavoritesFromFirestore() =>
      _favoriteService.loadFavoritesFromFirestore(_userId);
}
