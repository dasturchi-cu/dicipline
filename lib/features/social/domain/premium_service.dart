import 'package:shared_preferences/shared_preferences.dart';

/// Premium holati — referral mukofotlari va ijtimoiy funksiyalar uchun.
class PremiumService {
  PremiumService(this._prefs);

  static const _premiumKey = 'premium_active';
  static const _premiumExpiresKey = 'premium_expires_at';
  static const _referralCreditsKey = 'referral_premium_credits';

  final SharedPreferences _prefs;

  static Future<PremiumService> create() async {
    return PremiumService(await SharedPreferences.getInstance());
  }

  bool get isPremium {
    if (_prefs.getBool(_premiumKey) == true) {
      final expires = _prefs.getString(_premiumExpiresKey);
      if (expires == null) return true;
      return DateTime.parse(expires).isAfter(DateTime.now());
    }
    return false;
  }

  int get referralPremiumCredits =>
      _prefs.getInt(_referralCreditsKey) ?? 0;

  int get maxGroupMembers => isPremium ? 10 : 5;

  bool get hasPremiumShareCards => isPremium;

  double get referralXpMultiplier => isPremium ? 1.5 : 1.0;

  Future<void> activatePremium({Duration duration = const Duration(days: 7)}) async {
    await _prefs.setBool(_premiumKey, true);
    await _prefs.setString(
      _premiumExpiresKey,
      DateTime.now().add(duration).toIso8601String(),
    );
  }

  Future<void> grantReferralPremiumCredit() async {
    final credits = referralPremiumCredits + 1;
    await _prefs.setInt(_referralCreditsKey, credits);
    if (credits >= 3 && !isPremium) {
      await activatePremium(duration: const Duration(days: 3));
      await _prefs.setInt(_referralCreditsKey, 0);
    }
  }

  Future<void> deactivatePremium() async {
    await _prefs.setBool(_premiumKey, false);
    await _prefs.remove(_premiumExpiresKey);
  }
}
