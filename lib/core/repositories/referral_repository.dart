import 'package:isar/isar.dart';

import '../database/schemas/referral_entity.dart';

class ReferralRepository {
  ReferralRepository(this._isar);

  final Isar _isar;

  Future<List<ReferralEntity>> getAll() {
    return _isar.referralEntitys.where().sortByCreatedAtDesc().findAll();
  }

  Future<int> countAll() {
    return _isar.referralEntitys.count();
  }

  Future<int> countUnclaimedRewards() {
    return _isar.referralEntitys.filter().rewardClaimedEqualTo(false).count();
  }

  Future<ReferralEntity> save(ReferralEntity referral) async {
    await _isar.writeTxn(() async {
      await _isar.referralEntitys.put(referral);
    });
    return referral;
  }

  Future<bool> existsForLabel(String label) {
    return _isar.referralEntitys
        .filter()
        .referredLabelEqualTo(label)
        .count()
        .then((c) => c > 0);
  }
}
