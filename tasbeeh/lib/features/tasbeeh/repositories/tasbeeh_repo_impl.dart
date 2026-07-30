import '../models/tasbeeh_session.dart';
import '../services/tasbeeh_storage_service.dart';
import '../services/haptic_service.dart';
import '../services/sound_service.dart';
import 'tasbeeh_repository.dart';

class TasbeehRepositoryImpl implements TasbeehRepository {
  final TasbeehStorageService _storage;
  final HapticService _haptic;
  final SoundService _sound;

  TasbeehRepositoryImpl({
    required TasbeehStorageService storage,
    required HapticService haptic,
    required SoundService sound,
  }) : _storage = storage,
       _haptic = haptic,
       _sound = sound;

  @override
  Future<void> saveSession(TasbeehSession session) =>
      _storage.saveSession(session);

  @override
  Future<TasbeehSession?> getActiveSession() => _storage.getActiveSession();

  @override
  Future<TasbeehSession?> getSession(String id) => _storage.getSession(id);

  @override
  Future<void> deleteSession(String id) => _storage.deleteSession(id);

  @override
  Future<List<TasbeehSession>> getAllSessions() => _storage.getAllSessions();

  @override
  Future<void> vibrate() => _haptic.vibrate();

  @override
  Future<void> playClickSound() => _sound.playClickSound();
}
