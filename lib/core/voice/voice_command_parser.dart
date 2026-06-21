/// Ovoz buyrug'i natijasi.
class VoiceCommandResult {
  const VoiceCommandResult({
    required this.type,
    required this.message,
    this.createdTitle,
    this.actionRoute,
  });

  final String type;
  final String message;
  final String? createdTitle;
  final String? actionRoute;

  bool get isAction => type != 'chat';

  VoiceCommandResult copyWith({String? message}) {
    return VoiceCommandResult(
      type: type,
      message: message ?? this.message,
      createdTitle: createdTitle,
      actionRoute: actionRoute,
    );
  }
}

/// Ovoz matnini buyruqlarga ajratadi.
class VoiceCommandParser {
  const VoiceCommandParser();

  VoiceCommandResult parse(String transcript) {
    final text = transcript.trim();
    final lower = text.toLowerCase();

    if (_matchesCreateTask(lower)) {
      final title = _extractAfterKeywords(
        text,
        ['vazifa qo\'sh', 'vazifa yarat', 'vazifa', 'task'],
      );
      if (title.isNotEmpty) {
        return VoiceCommandResult(
          type: 'create_task',
          message: 'Vazifa yaratildi: $title',
          createdTitle: title,
          actionRoute: '/vazifalar',
        );
      }
    }

    if (_matchesCreateHabit(lower)) {
      final name = _extractAfterKeywords(
        text,
        ['odat qo\'sh', 'odat yarat', 'odat', 'habit'],
      );
      if (name.isNotEmpty) {
        return VoiceCommandResult(
          type: 'create_habit',
          message: 'Odat yaratildi: $name',
          createdTitle: name,
          actionRoute: '/vazifalar/odatlar',
        );
      }
    }

    if (_matchesPlan(lower)) {
      final planText = _extractAfterKeywords(
        text,
        ['reja tuz', 'reja yarat', 'bugun reja', 'plan'],
      );
      return VoiceCommandResult(
        type: 'create_plan',
        message: planText.isNotEmpty
            ? 'Reja yaratildi: $planText'
            : 'Bugungi reja yaratildi',
        createdTitle: planText.isNotEmpty ? planText : 'Bugungi reja',
        actionRoute: '/reja',
      );
    }

    if (_matchesHelp(lower)) {
      return const VoiceCommandResult(
        type: 'help',
        message: 'Buyruqlar: "vazifa qo\'sh ...", "odat qo\'sh ...", '
            '"reja tuz ..." yoki savol bering.',
      );
    }

    return VoiceCommandResult(
      type: 'chat',
      message: text,
    );
  }

  bool _matchesCreateTask(String lower) {
    return lower.contains('vazifa') ||
        lower.contains('task') ||
        lower.startsWith('qo\'sh ');
  }

  bool _matchesCreateHabit(String lower) {
    return lower.contains('odat') || lower.contains('habit');
  }

  bool _matchesPlan(String lower) {
    return lower.contains('reja') || lower.contains('plan');
  }

  bool _matchesHelp(String lower) {
    return lower.contains('yordam') ||
        lower.contains('help') ||
        lower.contains('buyruq');
  }

  String _extractAfterKeywords(String text, List<String> keywords) {
    var result = text;
    for (final kw in keywords) {
      final idx = result.toLowerCase().indexOf(kw.toLowerCase());
      if (idx >= 0) {
        result = result.substring(idx + kw.length).trim();
        break;
      }
    }
    result = result.replaceAll(RegExp(r'^[:\-,]+'), '').trim();
    if (result.length < 2) return '';
    return result[0].toUpperCase() + result.substring(1);
  }
}
