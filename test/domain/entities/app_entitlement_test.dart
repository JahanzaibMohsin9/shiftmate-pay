import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/domain/entities/app_entitlement.dart';

void main() {
  group('AppEntitlement', () {
    test('free() creates a free tier entitlement', () {
      final entitlement = AppEntitlement.free();
      expect(entitlement.premium, isFalse);
    });

    test('premium() creates a premium tier entitlement', () {
      final entitlement = AppEntitlement.premium();
      expect(entitlement.premium, isTrue);
    });

    group('canAccess', () {
      final freeEntitlement = AppEntitlement.free();
      final premiumEntitlement = AppEntitlement.premium();

      test('free tier can access basic features but not premium ones', () {
        // Basic features (if any were defined as free)
        // For now, most things are gated or handled by logic (like job count)
        // Let's check the ones we specifically gated
        expect(freeEntitlement.canAccess(AppFeature.export), isFalse);
        expect(freeEntitlement.canAccess(AppFeature.widgets), isFalse);
        expect(freeEntitlement.canAccess(AppFeature.advancedPayRules), isFalse);
        expect(freeEntitlement.canAccess(AppFeature.import), isFalse);
        expect(freeEntitlement.canAccess(AppFeature.reminders), isFalse);
      });

      test('premium tier can access all features', () {
        expect(premiumEntitlement.canAccess(AppFeature.export), isTrue);
        expect(premiumEntitlement.canAccess(AppFeature.widgets), isTrue);
        expect(
          premiumEntitlement.canAccess(AppFeature.advancedPayRules),
          isTrue,
        );
        expect(premiumEntitlement.canAccess(AppFeature.import), isTrue);
        expect(premiumEntitlement.canAccess(AppFeature.reminders), isTrue);
      });
    });
  });
}
