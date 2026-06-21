import 'package:rejabon_ai/core/database/schemas/referral_entity.dart';
import 'package:rejabon_ai/core/repositories/referral_repository.dart';
import 'package:rejabon_ai/features/social/domain/premium_service.dart';

/// Referral mukofot natijasi.
class ReferralRewardResult {
  const ReferralRewardResult({
    required this.referral,
    required this.xpAwarded,
    required this.premiumCreditGranted,
  });

  final ReferralEntity referral;
  final int xpAwarded;
  final bool premiumCreditGranted;
}

/// Taklif tizimi va mukofotlar.
class ReferralService {
  ReferralService({
    required ReferralRepository referralRepo,
    required PremiumService premiumService,
  })  : _referrals = referralRepo,
        _premium = premiumService;

  final ReferralRepository _referrals;
  final PremiumService _premium;

  static const rewardTiers = [
    (count: 1, xp: 100, label: 'Birinchi taklif'),
    (count: 3, xp: 200, label: '3 ta taklif'),
    (count: 5, xp: 500, label: '5 ta taklif + Premium sinov'),
  ];

  Future<ReferralRewardResult?> recordReferral({
    required String inviteCode,
    required String referredLabel,
    String source = 'partner_connect',
  }) async {
    if (await _referrals.existsForLabel(referredLabel)) return null;

    final baseXp = 100;
    final xp = (baseXp * _premium.referralXpMultiplier).round();

    final referral = ReferralEntity.create(
      usedInviteCode: inviteCode.toUpperCase(),
      referredLabel: referredLabel,
      source: source,
      rewardXp: xp,
    );
    await _referrals.save(referral);

    var premiumCredit = false;
    final total = await _referrals.countAll();
    if (total % 3 == 0) {
      await _premium.grantReferralPremiumCredit();
      premiumCredit = true;
    }

    return ReferralRewardResult(
      referral: referral,
      xpAwarded: xp,
      premiumCreditGranted: premiumCredit,
    );
  }

  Future<int> getTotalReferrals() => _referrals.countAll();

  Future<int> getTotalReferralXp() async {
    final all = await _referrals.getAll();
    return all.fold<int>(0, (sum, r) => sum + r.rewardXp);
  }

  Future<String> nextMilestoneMessage() async {
    final count = await _referrals.countAll();
    for (final tier in rewardTiers) {
      if (count < tier.count) {
        final remaining = tier.count - count;
        return '$remaining ta taklif qoldi: ${tier.label}';
      }
    }
    return 'Barcha bosqichlar ochilgan — davom eting!';
  }

  String buildShareMessage(String inviteCode, {String? userName}) {
    final name = userName?.trim();
    final greeting = name != null && name.isNotEmpty
        ? '$name sizni REJABON AI ga taklif qilmoqda!'
        : 'REJABON AI ga qo\'shiling!';
    return '$greeting\n\n'
        'Shaxsiy rivojlanish, odatlar va AI murabbiy — barchasi bir joyda.\n'
        'Taklif kodi: $inviteCode\n\n'
        '#REJABONAI #ShaxsiyRivojlanish';
  }
}
