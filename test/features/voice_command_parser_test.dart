import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/voice/voice_command_parser.dart';

void main() {
  group('VoiceCommandParser', () {
    const parser = VoiceCommandParser();

    test('parses create task command', () {
      final result = parser.parse('Vazifa qo\'sh hisobot tayyorlash');
      expect(result.type, 'create_task');
      expect(result.createdTitle, isNotNull);
      expect(result.createdTitle!.toLowerCase(), contains('hisobot'));
    });

    test('parses create habit command', () {
      final result = parser.parse('Odat qo\'sh yugurish');
      expect(result.type, 'create_habit');
      expect(result.createdTitle, 'Yugurish');
    });

    test('parses plan command', () {
      final result = parser.parse('Reja tuz dars, sport, o\'qish');
      expect(result.type, 'create_plan');
      expect(result.actionRoute, '/reja');
    });

    test('falls back to chat for questions', () {
      final result = parser.parse('Bugun nima qilishim kerak?');
      expect(result.type, 'chat');
    });
  });
}
