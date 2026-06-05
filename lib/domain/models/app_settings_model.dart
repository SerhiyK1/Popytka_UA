class AppSettingsModel {
  final String languageCode;
  final bool isDarkMode;
  final bool notifyRideUpdates;
  final bool notifyNewMessages;
  final bool notifyPromotions;
  final String dataSharing;
  final bool profilePublic;
  final bool twoFactorEnabled;

  const AppSettingsModel({
    this.languageCode = 'uk',
    this.isDarkMode = true,
    this.notifyRideUpdates = true,
    this.notifyNewMessages = true,
    this.notifyPromotions = true,
    this.dataSharing = 'selective',
    this.profilePublic = true,
    this.twoFactorEnabled = false,
  });

  AppSettingsModel copyWith({
    String? languageCode,
    bool? isDarkMode,
    bool? notifyRideUpdates,
    bool? notifyNewMessages,
    bool? notifyPromotions,
    String? dataSharing,
    bool? profilePublic,
    bool? twoFactorEnabled,
  }) {
    return AppSettingsModel(
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notifyRideUpdates: notifyRideUpdates ?? this.notifyRideUpdates,
      notifyNewMessages: notifyNewMessages ?? this.notifyNewMessages,
      notifyPromotions: notifyPromotions ?? this.notifyPromotions,
      dataSharing: dataSharing ?? this.dataSharing,
      profilePublic: profilePublic ?? this.profilePublic,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'isDarkMode': isDarkMode,
      'notifyRideUpdates': notifyRideUpdates,
      'notifyNewMessages': notifyNewMessages,
      'notifyPromotions': notifyPromotions,
      'dataSharing': dataSharing,
      'profilePublic': profilePublic,
      'twoFactorEnabled': twoFactorEnabled,
    };
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      languageCode: json['languageCode'] as String? ?? 'uk',
      isDarkMode: json['isDarkMode'] as bool? ?? true,
      notifyRideUpdates: json['notifyRideUpdates'] as bool? ?? true,
      notifyNewMessages: json['notifyNewMessages'] as bool? ?? true,
      notifyPromotions: json['notifyPromotions'] as bool? ?? true,
      dataSharing: json['dataSharing'] as String? ?? 'selective',
      profilePublic: json['profilePublic'] as bool? ?? true,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
    );
  }
}
