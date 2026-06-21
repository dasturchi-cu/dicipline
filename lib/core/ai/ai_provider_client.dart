import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_config.dart';
import 'ai_types.dart';

abstract class AiProviderClient {
  AiProviderId get id;

  Future<String> complete({
    required ProviderConfig config,
    required String model,
    required String apiKey,
    required AiCompletionRequest request,
    required Duration timeout,
  });
}

bool isQuotaOrRateLimitError(int statusCode, String body) {
  if (statusCode == 429 || statusCode == 402) return true;
  if (statusCode == 403 || statusCode == 503) {
    final lower = body.toLowerCase();
    return lower.contains('quota') ||
        lower.contains('rate limit') ||
        lower.contains('rate_limit') ||
        lower.contains('billing') ||
        lower.contains('exceeded') ||
        lower.contains('resource_exhausted') ||
        lower.contains('insufficient');
  }
  return false;
}

void throwForResponse(http.Response response) {
  final body = response.body;
  if (isQuotaOrRateLimitError(response.statusCode, body)) {
    throw AiQuotaException(body, statusCode: response.statusCode);
  }
  throw AiRequestException(body, statusCode: response.statusCode);
}

class GeminiClient implements AiProviderClient {
  @override
  AiProviderId get id => AiProviderId.gemini;

  @override
  Future<String> complete({
    required ProviderConfig config,
    required String model,
    required String apiKey,
    required AiCompletionRequest request,
    required Duration timeout,
  }) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$model:generateContent?key=$apiKey',
    );

    final contents = <Map<String, dynamic>>[];
    if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty) {
      contents.add({
        'role': 'user',
        'parts': [
          {'text': request.systemPrompt!},
        ],
      });
      contents.add({
        'role': 'model',
        'parts': [
          {'text': 'Tushundim.'},
        ],
      });
    }

    for (final message in request.messages) {
      contents.add({
        'role': message.role == 'assistant' ? 'model' : 'user',
        'parts': [
          {'text': message.content},
        ],
      });
    }

    final payload = {
      'contents': contents,
      'generationConfig': {
        'temperature': request.temperature,
        'maxOutputTokens':
            request.maxOutputTokens ?? config.maxOutputTokens ?? 8192,
      },
    };

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(timeout);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      final content = candidates?.firstOrNull?['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      final text = parts?.firstOrNull?['text'] as String?;
      if (text != null && text.trim().isNotEmpty) return text.trim();
      throw AiRequestException('Gemini javob qaytarmadi', statusCode: 200);
    }

    throwForResponse(response);
    return '';
  }
}

class OpenAiCompatibleClient implements AiProviderClient {
  OpenAiCompatibleClient({
    required this.id,
    required this.baseUrl,
    this.extraHeaders = const {},
  });

  @override
  final AiProviderId id;
  final String baseUrl;
  final Map<String, String> extraHeaders;

  @override
  Future<String> complete({
    required ProviderConfig config,
    required String model,
    required String apiKey,
    required AiCompletionRequest request,
    required Duration timeout,
  }) async {
    final messages = <Map<String, String>>[];
    if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty) {
      messages.add({'role': 'system', 'content': request.systemPrompt!});
    }
    for (final message in request.messages) {
      messages.add({'role': message.role, 'content': message.content});
    }

    final payload = {
      'model': model,
      'messages': messages,
      'temperature': request.temperature,
      if (request.maxOutputTokens != null)
        'max_tokens': request.maxOutputTokens,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
      ...extraHeaders,
    };

    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: headers,
          body: jsonEncode(payload),
        )
        .timeout(timeout);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      final text = choices?.firstOrNull?['message']?['content'] as String?;
      if (text != null && text.trim().isNotEmpty) return text.trim();
      throw AiRequestException('OpenAI-compatible javob qaytarmadi', statusCode: 200);
    }

    throwForResponse(response);
    return '';
  }
}

class CloudflareClient implements AiProviderClient {
  @override
  AiProviderId get id => AiProviderId.cloudflare;

  @override
  Future<String> complete({
    required ProviderConfig config,
    required String model,
    required String apiKey,
    required AiCompletionRequest request,
    required Duration timeout,
  }) async {
    final accountId = config.accountId;
    if (accountId == null || accountId.isEmpty) {
      throw AiRequestException('Cloudflare account ID yo\'q');
    }

    final uri = Uri.parse(
      'https://api.cloudflare.com/client/v4/accounts/$accountId/ai/run/$model',
    );

    final promptBuffer = StringBuffer();
    if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty) {
      promptBuffer.writeln(request.systemPrompt);
    }
    for (final message in request.messages) {
      promptBuffer.writeln('${message.role}: ${message.content}');
    }

    final payload = {
      'messages': [
        for (final message in request.messages)
          {'role': message.role, 'content': message.content},
      ],
      if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty)
        'system': request.systemPrompt,
      'prompt': promptBuffer.toString(),
    };

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(payload),
        )
        .timeout(timeout);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        final result = data['result'];
        if (result is Map<String, dynamic>) {
          final responseText = result['response'] as String?;
          if (responseText != null && responseText.trim().isNotEmpty) {
            return responseText.trim();
          }
        }
        if (result is String && result.trim().isNotEmpty) {
          return result.trim();
        }
      }
      if (data is String && data.trim().isNotEmpty) return data.trim();
      throw AiRequestException('Cloudflare javob qaytarmadi', statusCode: 200);
    }

    throwForResponse(response);
    return '';
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

Map<AiProviderId, AiProviderClient> createDefaultAiClients(AiConfig config) {
  final openRouterConfig = config.providers[AiProviderId.openrouter];
  return {
    AiProviderId.gemini: GeminiClient(),
    AiProviderId.openai: OpenAiCompatibleClient(
      id: AiProviderId.openai,
      baseUrl: 'https://api.openai.com/v1/chat/completions',
    ),
    AiProviderId.openrouter: OpenAiCompatibleClient(
      id: AiProviderId.openrouter,
      baseUrl: 'https://openrouter.ai/api/v1/chat/completions',
      extraHeaders: {
        if (openRouterConfig?.httpReferer != null)
          'HTTP-Referer': openRouterConfig!.httpReferer!,
        if (openRouterConfig?.xTitle != null)
          'X-Title': openRouterConfig!.xTitle!,
      },
    ),
    AiProviderId.groq: OpenAiCompatibleClient(
      id: AiProviderId.groq,
      baseUrl: 'https://api.groq.com/openai/v1/chat/completions',
    ),
    AiProviderId.cloudflare: CloudflareClient(),
  };
}
