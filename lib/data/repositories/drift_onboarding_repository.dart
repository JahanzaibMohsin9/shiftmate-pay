import '../../core/common/result.dart';
import '../../domain/repositories/repositories.dart';
import '../local/preferences/app_preferences.dart';
import 'repository_utils.dart';

class DriftOnboardingRepository implements OnboardingRepository {
  DriftOnboardingRepository(this._preferences);

  final AppPreferences _preferences;

  @override
  Future<Result<bool>> hasCompletedOnboarding() {
    return guardResult(() async => _preferences.onboardingCompleted);
  }

  @override
  Future<Result<void>> setOnboardingCompleted() {
    return guardResult(() async {
      await _preferences.setOnboardingCompleted(true);
    });
  }
}
