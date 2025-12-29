import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/llm_message.dart';
import '../models/app_settings.dart';
import '../models/agent_config.dart';

class LlmProvider {
  final Dio _dio;

  LlmProvider() : _dio = Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  Future<String> chatRawJson({
    required List<LlmMessage> messages,
    required AppSettings settings,
    required AgentConfig cfg,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        settings.baseUrl,
        data: {
          'model': cfg.model,
          'messages': messages.map((m) => m.toJson()).toList(),
          'temperature': cfg.temperature,
          'max_tokens': cfg.maxTokens,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${settings.apiKey}',
            'Content-Type': 'application/json',
          },
        ),
        cancelToken: cancelToken,
      );

      // Extract assistant content from OpenAI-compatible response
      final choices = response.data['choices'];
      if (choices != null && choices.isNotEmpty) {
        final message = choices[0]['message'];
        if (message != null) {
          return message['content'] ?? '';
        }
      }

      throw Exception('Invalid response format from LLM');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        // Retry once for network errors
        debugPrint('Network error, retrying once...');
        return await _retryRequest(
          messages: messages,
          settings: settings,
          cfg: cfg,
          cancelToken: cancelToken,
        );
      }
      rethrow;
    }
  }

  Future<String> _retryRequest({
    required List<LlmMessage> messages,
    required AppSettings settings,
    required AgentConfig cfg,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post(
      settings.baseUrl,
      data: {
        'model': cfg.model,
        'messages': messages.map((m) => m.toJson()).toList(),
        'temperature': cfg.temperature,
        'max_tokens': cfg.maxTokens,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${settings.apiKey}',
          'Content-Type': 'application/json',
        },
      ),
      cancelToken: cancelToken,
    );

    final choices = response.data['choices'];
    if (choices != null && choices.isNotEmpty) {
      final message = choices[0]['message'];
      if (message != null) {
        return message['content'] ?? '';
      }
    }

    throw Exception('Invalid response format from LLM');
  }
}
