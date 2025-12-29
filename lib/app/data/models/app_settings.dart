import 'agent_config.dart';

class AppSettings {
  final String baseUrl;
  final String apiKey;
  final String targetLang;
  final String toneProfile;
  final List<String> formatRules;
  final Map<String, String> glossary;
  final AgentConfig agent1;
  final AgentConfig agent2;
  final AgentConfig agent3;

  AppSettings({
    required this.baseUrl,
    required this.apiKey,
    required this.targetLang,
    required this.toneProfile,
    required this.formatRules,
    required this.glossary,
    required this.agent1,
    required this.agent2,
    required this.agent3,
  });

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'targetLang': targetLang,
      'toneProfile': toneProfile,
      'formatRules': formatRules,
      'glossary': glossary,
      'agent1': agent1.toJson(),
      'agent2': agent2.toJson(),
      'agent3': agent3.toJson(),
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final formatRulesList = json['formatRules'];
    final glossaryMap = json['glossary'];

    return AppSettings(
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
      targetLang: json['targetLang'] ?? 'Vietnamese',
      toneProfile: json['toneProfile'] ?? '',
      formatRules: formatRulesList != null
          ? List<String>.from(formatRulesList)
          : <String>[],
      glossary: glossaryMap != null
          ? Map<String, String>.from(glossaryMap)
          : <String, String>{},
      agent1: json['agent1'] != null
          ? AgentConfig.fromJson(Map<String, dynamic>.from(json['agent1']))
          : _defaultAgent1(),
      agent2: json['agent2'] != null
          ? AgentConfig.fromJson(Map<String, dynamic>.from(json['agent2']))
          : _defaultAgent2(),
      agent3: json['agent3'] != null
          ? AgentConfig.fromJson(Map<String, dynamic>.from(json['agent3']))
          : _defaultAgent3(),
    );
  }

  static AgentConfig _defaultAgent1() {
    return AgentConfig(
      name: 'Translator',
      model: 'gpt-4o-mini',
      temperature: 0.3,
      maxTokens: 4000,
      systemPrompt: '''You are a professional translator.
Preserve meaning, numbers, proper nouns, and structure.
Follow glossary strictly.
Return JSON only, no extra text.''',
      userPromptTemplate: '''Translate the text to {{TARGET_LANG}}.

Rules:
- Preserve formatting: headings, bullet points, line breaks.
- Do NOT add new information.
- Apply glossary mappings strictly (if term appears, use mapped translation).
- Keep numbers, currency, units unchanged.
- If ambiguous, choose the most neutral/common meaning.

Tone profile (wording preference, do not change meaning):
{{TONE_PROFILE}}

Glossary (JSON map):
{{GLOSSARY}}

Format rules:
{{FORMAT_RULES}}

Text:
{{SOURCE_TEXT}}

Return ONLY JSON with this schema:
{
  "translation": "string",
  "notes": ["string"]
}''',
    );
  }

  static AgentConfig _defaultAgent2() {
    return AgentConfig(
      name: 'Stylist',
      model: 'gpt-4o-mini',
      temperature: 0.5,
      maxTokens: 4000,
      systemPrompt: '''You are an editor.
Improve fluency and match the given tone WITHOUT changing meaning.
Enforce glossary and preserve formatting.
Return JSON only.''',
      userPromptTemplate: '''Refine the translation to match the style.

Constraints:
- Do NOT change meaning.
- Keep formatting and order.
- Enforce glossary.
- Make wording consistent with tone profile.

Tone profile:
{{TONE_PROFILE}}

Glossary:
{{GLOSSARY}}

Original source:
{{SOURCE_TEXT}}

Current translation:
{{STEP1_TRANSLATION}}

Return ONLY JSON:
{
  "refined": "string",
  "changes": [
    {"type":"wording|tone|glossary|format", "before":"...", "after":"..."}
  ]
}''',
    );
  }

  static AgentConfig _defaultAgent3() {
    return AgentConfig(
      name: 'QA',
      model: 'gpt-4o-mini',
      temperature: 0.2,
      maxTokens: 4000,
      systemPrompt: '''You are a QA linguist.
Detect meaning drift, missing content, numeric mistakes, glossary violations, and formatting issues.
Fix issues and return JSON only.''',
      userPromptTemplate: '''Check translation quality.

Source:
{{SOURCE_TEXT}}

Candidate translation:
{{STEP2_REFINED}}

Glossary:
{{GLOSSARY}}

Return ONLY JSON:
{
  "final": "string",
  "issues": [
    {
      "severity": "low|medium|high",
      "type": "missing|mistranslation|number|glossary|format|grammar",
      "source_excerpt": "...",
      "target_excerpt": "...",
      "suggestion": "..."
    }
  ],
  "score": 0-100
}

Rules:
- If issues exist, fix them in "final".
- Preserve formatting.''',
    );
  }

  factory AppSettings.defaultSettings() {
    return AppSettings(
      baseUrl: '',
      apiKey: '',
      targetLang: 'Vietnamese',
      toneProfile:
          'Văn phong tự nhiên, rõ ràng, gọn; ưu tiên dễ hiểu như nói chuyện đời thường.\nKhông thêm ý. Không suy diễn. Giữ đúng nghĩa nguồn.',
      formatRules: [
        'Preserve headings and bullet points',
        'Preserve line breaks',
        'Keep numbers/units unchanged',
        'Do not translate code blocks',
        'Keep proper nouns unchanged unless glossary says otherwise',
      ],
      glossary: {},
      agent1: _defaultAgent1(),
      agent2: _defaultAgent2(),
      agent3: _defaultAgent3(),
    );
  }

  AppSettings copyWith({
    String? baseUrl,
    String? apiKey,
    String? targetLang,
    String? toneProfile,
    List<String>? formatRules,
    Map<String, String>? glossary,
    AgentConfig? agent1,
    AgentConfig? agent2,
    AgentConfig? agent3,
  }) {
    return AppSettings(
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      targetLang: targetLang ?? this.targetLang,
      toneProfile: toneProfile ?? this.toneProfile,
      formatRules: formatRules ?? this.formatRules,
      glossary: glossary ?? this.glossary,
      agent1: agent1 ?? this.agent1,
      agent2: agent2 ?? this.agent2,
      agent3: agent3 ?? this.agent3,
    );
  }
}
