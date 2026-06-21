import 'package:rejabon_ai/core/database/schemas/partnership_entity.dart';
import 'package:rejabon_ai/core/repositories/partnership_repository.dart';
import 'package:rejabon_ai/core/repositories/social_settings_repository.dart';
import 'package:rejabon_ai/features/social/domain/friend_challenge_service.dart';
import 'package:rejabon_ai/features/social/domain/referral_service.dart';

/// Hamkorlik holati.
class PartnerSummary {
  const PartnerSummary({
    required this.partner,
    required this.daysConnected,
    required this.canCheckInToday,
  });

  final PartnershipEntity partner;
  final int daysConnected;
  final bool canCheckInToday;
}

/// Kengaytirilgan ijtimoiy tizim.
class SocialService {
  SocialService({
    required PartnershipRepository repo,
    required SocialSettingsRepository settingsRepo,
    required ReferralService referralService,
    FriendChallengeService? friendChallengeService,
  })  : _repo = repo,
        _settingsRepo = settingsRepo,
        _referrals = referralService,
        _friendChallenges = friendChallengeService;

  final PartnershipRepository _repo;
  final SocialSettingsRepository _settingsRepo;
  final ReferralService _referrals;
  final FriendChallengeService? _friendChallenges;

  Future<String> getMyInviteCode() async {
    final existing = await _repo.getAll();
    final mine = existing.where((p) => p.partnerName == 'Mening kodi').toList();
    if (mine.isNotEmpty) return mine.first.inviteCode;

    final code = await _repo.generateUniqueCode();
    await _repo.create(
      PartnershipEntity.create(
        inviteCode: code,
        partnerName: 'Mening kodi',
      ),
    );
    return code;
  }

  Future<PartnershipEntity> connectPartner({
    required String inviteCode,
    required String partnerName,
  }) async {
    final normalized = inviteCode.trim().toUpperCase();
    final myCode = await getMyInviteCode();
    if (normalized == myCode) {
      throw SocialException('O\'z kodingizni kirita olmaysiz');
    }

    final existing = await _repo.getByCode(normalized);
    if (existing != null &&
        existing.partnerName != 'Mening kodi' &&
        existing.partnerName != partnerName) {
      return existing;
    }

    PartnershipEntity partner;
    if (existing != null && existing.partnerName == 'Mening kodi') {
      existing.partnerName = partnerName;
      partner = await _repo.create(existing);
    } else {
      partner = await _repo.create(
        PartnershipEntity.create(
          inviteCode: normalized,
          partnerName: partnerName,
        ),
      );
    }

    await _referrals.recordReferral(
      inviteCode: myCode,
      referredLabel: partnerName,
      source: 'partner_connect',
    );

    return partner;
  }

  Future<PartnershipEntity?> checkIn(int partnershipId) async {
    final all = await _repo.getAll();
    final partner = all.cast<PartnershipEntity?>().firstWhere(
          (p) => p?.id == partnershipId,
          orElse: () => null,
        );
    if (partner == null || partner.partnerName == 'Mening kodi') return null;

    if (partner.lastCheckInAt != null) {
      final last = partner.lastCheckInAt!;
      final today = DateTime.now();
      if (last.year == today.year &&
          last.month == today.month &&
          last.day == today.day) {
        return partner;
      }
    }

    final updated = await _repo.checkIn(partner);
    await _friendChallenges?.syncPartnerProgress(partner: updated);
    return updated;
  }

  Future<List<PartnerSummary>> getPartnerSummaries() async {
    final partners = await _repo.getAll();
    final now = DateTime.now();
    return partners
        .where((p) => p.partnerName != 'Mening kodi')
        .map((p) {
          final days = now.difference(p.connectedAt).inDays;
          final canCheckIn = p.lastCheckInAt == null ||
              p.lastCheckInAt!.day != now.day ||
              p.lastCheckInAt!.month != now.month;
          return PartnerSummary(
            partner: p,
            daysConnected: days,
            canCheckInToday: canCheckIn,
          );
        })
        .toList();
  }

  Future<void> updatePartnerPrivacy({
    required int partnershipId,
    bool? shareStreaks,
    bool? shareGoals,
    bool? shareAchievements,
  }) async {
    final all = await _repo.getAll();
    final partner = all.cast<PartnershipEntity?>().firstWhere(
          (p) => p?.id == partnershipId,
          orElse: () => null,
        );
    if (partner == null) return;

    if (shareStreaks != null) partner.shareStreaks = shareStreaks;
    if (shareGoals != null) partner.shareGoals = shareGoals;
    if (shareAchievements != null) {
      partner.shareAchievements = shareAchievements;
    }
    await _repo.create(partner);
  }

  Future<bool> removePartner(int partnershipId) =>
      _repo.delete(partnershipId);

  Future<List<PartnershipEntity>> getPartners() => _repo.getAll();

  SocialSettingsRepository get settingsRepo => _settingsRepo;
}

class SocialException implements Exception {
  SocialException(this.message);
  final String message;

  @override
  String toString() => message;
}
