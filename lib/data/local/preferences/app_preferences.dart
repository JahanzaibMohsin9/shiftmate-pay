import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ExportHistoryEntry {
  const ExportHistoryEntry({
    required this.id,
    required this.type,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String fileName;
  final String filePath;
  final DateTime createdAt;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'type': type,
      'fileName': fileName,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ExportHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ExportHistoryEntry(
      id: json['id'] as String,
      type: json['type'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AppPreferences {
  AppPreferences(this._preferences);

  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _premiumUnlockedKey = 'premium_unlocked';
  static const _premiumStateSnapshotKey = 'premium_state_snapshot';
  static const _exportHistoryKey = 'export_history';
  static const _themeModeKey = 'theme_mode';
  static const _advancedPayFollowUpSeenKey = 'advanced_pay_follow_up_seen';
  static const _importFollowUpSeenKey = 'import_follow_up_seen';
  static const _verificationFollowUpSeenKey = 'verification_follow_up_seen';

  final SharedPreferences _preferences;

  static Future<AppPreferences> create() async {
    final preferences = await SharedPreferences.getInstance();
    return AppPreferences(preferences);
  }

  bool get onboardingCompleted =>
      _preferences.getBool(_onboardingCompletedKey) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _preferences.setBool(_onboardingCompletedKey, value);
  }

  bool get premiumUnlocked =>
      _preferences.getBool(_premiumUnlockedKey) ?? false;

  Future<void> setPremiumUnlocked(bool value) async {
    await _preferences.setBool(_premiumUnlockedKey, value);
  }

  String? get premiumStateSnapshotJson =>
      _preferences.getString(_premiumStateSnapshotKey);

  Future<void> setPremiumStateSnapshotJson(String value) async {
    await _preferences.setString(_premiumStateSnapshotKey, value);
  }

  Future<void> clearPremiumStateSnapshot() async {
    await _preferences.remove(_premiumStateSnapshotKey);
  }

  String get themeModePreference =>
      _preferences.getString(_themeModeKey) ?? 'system';

  Future<void> setThemeModePreference(String value) async {
    await _preferences.setString(_themeModeKey, value);
  }

  bool get advancedPayFollowUpSeen =>
      _preferences.getBool(_advancedPayFollowUpSeenKey) ?? false;

  Future<void> setAdvancedPayFollowUpSeen(bool value) async {
    await _preferences.setBool(_advancedPayFollowUpSeenKey, value);
  }

  bool get importFollowUpSeen =>
      _preferences.getBool(_importFollowUpSeenKey) ?? false;

  Future<void> setImportFollowUpSeen(bool value) async {
    await _preferences.setBool(_importFollowUpSeenKey, value);
  }

  bool get verificationFollowUpSeen =>
      _preferences.getBool(_verificationFollowUpSeenKey) ?? false;

  Future<void> setVerificationFollowUpSeen(bool value) async {
    await _preferences.setBool(_verificationFollowUpSeenKey, value);
  }

  List<ExportHistoryEntry> get exportHistory {
    final rawEntries =
        _preferences.getStringList(_exportHistoryKey) ?? const <String>[];
    return rawEntries
        .map(
          (entry) => ExportHistoryEntry.fromJson(
            jsonDecode(entry) as Map<String, dynamic>,
          ),
        )
        .toList(growable: false);
  }

  Future<void> addExportHistoryEntry(ExportHistoryEntry entry) async {
    final next = [
      jsonEncode(entry.toJson()),
      ...exportHistory.map((item) => jsonEncode(item.toJson())),
    ].take(20).toList(growable: false);

    await _preferences.setStringList(_exportHistoryKey, next);
  }
}
