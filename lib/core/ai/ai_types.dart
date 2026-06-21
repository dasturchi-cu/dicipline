enum AiProviderId {
  gemini,
  openai,
  openrouter,
  groq,
  cloudflare,
}

class AiMessage {
  const AiMessage({required this.role, required this.content});

  final String role;
  final String content;
}

class AiCompletionRequest {
  const AiCompletionRequest({
    required this.messages,
    this.systemPrompt,
    this.maxOutputTokens,
    this.temperature = 0.7,
  });

  final List<AiMessage> messages;
  final String? systemPrompt;
  final int? maxOutputTokens;
  final double temperature;
}

class AiCompletionResult {
  const AiCompletionResult({
    required this.text,
    required this.provider,
    required this.model,
    required this.keyIndex,
  });

  final String text;
  final AiProviderId provider;
  final String model;
  final int keyIndex;
}

class AiQuotaException implements Exception {
  AiQuotaException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AiQuotaException($statusCode): $message';
}

class AiRequestException implements Exception {
  AiRequestException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AiRequestException($statusCode): $message';
}

class AiRouteTarget {
  const AiRouteTarget({
    required this.provider,
    required this.modelIndex,
    required this.keyIndex,
  });

  final AiProviderId provider;
  final int modelIndex;
  final int keyIndex;
}
