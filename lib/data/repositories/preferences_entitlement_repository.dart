import '../../core/common/result.dart';
import '../../domain/entities/app_entitlement.dart';
import '../../domain/repositories/repositories.dart';
import '../local/preferences/app_preferences.dart';
import '../../features/premium/domain/premium_state.dart';
import 'repository_utils.dart';

class PreferencesEntitlementRepository implements EntitlementRepository {
  PreferencesEntitlementRepository(this._preferences);

  final AppPreferences _preferences;

  @override
  Future<Result<AppEntitlement>> getEntitlement() {
    return guardResult(() async {
      final snapshotJson = _preferences.premiumStateSnapshotJson;
      if (snapshotJson == null || snapshotJson.isEmpty) {
        return AppEntitlement.free();
      }

      final snapshot = PremiumState.fromJsonString(snapshotJson);
      return snapshot.entitlement;
    });
  }
}
