import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/features/social/domain/share_card_service.dart';

void main() {
  group('ShareCardService', () {
    test('buildShareText includes title and hashtag', () {
      const data = ShareCardData(
        type: ShareCardType.achievement,
        title: '7 kunlik olov',
        subtitle: 'Odat streak',
        emoji: '🔥',
        statLine: '7 kun',
      );

      final text = ShareCardService.buildShareText(data);
      expect(text, contains('7 kunlik olov'));
      expect(text, contains('#REJABONAI'));
    });
  });
}
