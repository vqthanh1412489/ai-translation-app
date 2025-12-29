import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/llm_message.dart';
import '../models/app_settings.dart';
import '../models/agent_config.dart';
import '../providers/llm_provider.dart';

class LlmRepository {
  final LlmProvider _llmProvider;

  LlmRepository(this._llmProvider);

  Future<Map<String, dynamic>> runAgent1Translate({
    required String sourceText,
    required AppSettings settings,
    CancelToken? cancelToken,
  }) async {
    return await _runAgentWithRetry(
      agentConfig: settings.agent1,
      settings: settings,
      variables: {
        'SOURCE_TEXT': sourceText,
        'TARGET_LANG': settings.targetLang,
        'TONE_PROFILE': settings.toneProfile,
        'GLOSSARY': jsonEncode(settings.glossary),
        'FORMAT_RULES': settings.formatRules.join('\n'),
      },
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> runAgent2Style({
    required String sourceText,
    required String step1Translation,
    required AppSettings settings,
    CancelToken? cancelToken,
  }) async {
    return await _runAgentWithRetry(
      agentConfig: settings.agent2,
      settings: settings,
      variables: {
        'SOURCE_TEXT': sourceText,
        'STEP1_TRANSLATION': step1Translation,
        'TARGET_LANG': settings.targetLang,
        'TONE_PROFILE': settings.toneProfile,
        'GLOSSARY': jsonEncode(settings.glossary),
      },
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> runAgent3Qa({
    required String sourceText,
    required String step2Refined,
    required AppSettings settings,
    CancelToken? cancelToken,
  }) async {
    return await _runAgentWithRetry(
      agentConfig: settings.agent3,
      settings: settings,
      variables: {
        'SOURCE_TEXT': sourceText,
        'STEP2_REFINED': step2Refined,
        'GLOSSARY': jsonEncode(settings.glossary),
      },
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> _runAgentWithRetry({
    required AgentConfig agentConfig,
    required AppSettings settings,
    required Map<String, String> variables,
    CancelToken? cancelToken,
  }) async {
    // Build messages
    final messages = _buildMessages(agentConfig, variables);

    // First attempt
    String rawResponse = await _llmProvider.chatRawJson(
      messages: messages,
      settings: settings,
      cfg: agentConfig,
      cancelToken: cancelToken,
    );

    // Try to parse JSON
    try {
      final parsed = jsonDecode(rawResponse);
      if (parsed is Map<String, dynamic>) {
        return {
          'success': true,
          'data': parsed,
          'raw': rawResponse,
        };
      }
      throw const FormatException('Response is not a JSON object');
    } catch (e) {
      debugPrint('JSON parse error on first attempt: $e');
      debugPrint('Raw response: $rawResponse');

      // Retry with Fix JSON prompt
      return await _retryWithFixJsonPrompt(
        previousOutput: rawResponse,
        agentConfig: agentConfig,
        settings: settings,
        cancelToken: cancelToken,
      );
    }
  }

  Future<Map<String, dynamic>> _retryWithFixJsonPrompt({
    required String previousOutput,
    required AgentConfig agentConfig,
    required AppSettings settings,
    CancelToken? cancelToken,
  }) async {
    debugPrint('Retrying with Fix JSON prompt...');

    final fixMessages = [
      LlmMessage(
        role: 'system',
        content: agentConfig.systemPrompt,
      ),
      LlmMessage(
        role: 'user',
        content:
            '''You returned invalid JSON. Return ONLY valid JSON matching the schema exactly. Do not add any extra text.
Here is your previous output:
$previousOutput''',
      ),
    ];

    final rawResponse = await _llmProvider.chatRawJson(
      messages: fixMessages,
      settings: settings,
      cfg: agentConfig,
      cancelToken: cancelToken,
    );

    try {
      final parsed = jsonDecode(rawResponse);
      if (parsed is Map<String, dynamic>) {
        return {
          'success': true,
          'data': parsed,
          'raw': rawResponse,
        };
      }
      throw const FormatException('Response is not a JSON object');
    } catch (e) {
      debugPrint('JSON parse error on retry: $e');
      // Return error with raw output
      return {
        'success': false,
        'error': 'Failed to parse JSON after retry',
        'raw': rawResponse,
      };
    }
  }

  List<LlmMessage> _buildMessages(
    AgentConfig config,
    Map<String, String> variables,
  ) {
    String userPrompt = config.userPromptTemplate;

    // Replace variables
    variables.forEach((key, value) {
      userPrompt = userPrompt.replaceAll('{{$key}}', value);
    });

    return [
      LlmMessage(
        role: 'system',
        content: config.systemPrompt,
      ),
      LlmMessage(
        role: 'user',
        content: userPrompt,
      ),
    ];
  }
}
