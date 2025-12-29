class Job {
  final String id;
  final String createdAt;
  final String sourceText;

  // Snapshot settings at runtime
  final String targetLang;
  final String toneProfile;
  final List<String> formatRules;
  final Map<String, String> glossary;

  // Raw JSON per step
  final String? step1JsonRaw;
  final String? step2JsonRaw;
  final String? step3JsonRaw;

  // Parsed outputs
  final String? step1Text;
  final String? step2Text;
  final String? finalText;
  final List<Map<String, dynamic>>? qaIssues;
  final int? score;

  // Status
  final String status; // "idle" | "running" | "done" | "error"
  final String? errorMessage;

  Job({
    required this.id,
    required this.createdAt,
    required this.sourceText,
    required this.targetLang,
    required this.toneProfile,
    required this.formatRules,
    required this.glossary,
    this.step1JsonRaw,
    this.step2JsonRaw,
    this.step3JsonRaw,
    this.step1Text,
    this.step2Text,
    this.finalText,
    this.qaIssues,
    this.score,
    required this.status,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'sourceText': sourceText,
      'targetLang': targetLang,
      'toneProfile': toneProfile,
      'formatRules': formatRules,
      'glossary': glossary,
      'step1JsonRaw': step1JsonRaw,
      'step2JsonRaw': step2JsonRaw,
      'step3JsonRaw': step3JsonRaw,
      'step1Text': step1Text,
      'step2Text': step2Text,
      'finalText': finalText,
      'qaIssues': qaIssues,
      'score': score,
      'status': status,
      'errorMessage': errorMessage,
    };
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    final formatRulesList = json['formatRules'];
    final glossaryMap = json['glossary'];
    final qaIssuesList = json['qaIssues'];

    return Job(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      sourceText: json['sourceText'] ?? '',
      targetLang: json['targetLang'] ?? '',
      toneProfile: json['toneProfile'] ?? '',
      formatRules: formatRulesList != null
          ? List<String>.from(formatRulesList)
          : <String>[],
      glossary: glossaryMap != null
          ? Map<String, String>.from(glossaryMap)
          : <String, String>{},
      step1JsonRaw: json['step1JsonRaw'],
      step2JsonRaw: json['step2JsonRaw'],
      step3JsonRaw: json['step3JsonRaw'],
      step1Text: json['step1Text'],
      step2Text: json['step2Text'],
      finalText: json['finalText'],
      qaIssues: qaIssuesList != null
          ? List<Map<String, dynamic>>.from(
              qaIssuesList.map((e) => Map<String, dynamic>.from(e)))
          : null,
      score: json['score'],
      status: json['status'] ?? 'idle',
      errorMessage: json['errorMessage'],
    );
  }

  copyWith({
    String? id,
    String? createdAt,
    String? sourceText,
    String? targetLang,
    String? toneProfile,
    List<String>? formatRules,
    Map<String, String>? glossary,
    String? step1JsonRaw,
    String? step2JsonRaw,
    String? step3JsonRaw,
    String? step1Text,
    String? step2Text,
    String? finalText,
    List<Map<String, dynamic>>? qaIssues,
    int? score,
    String? status,
    String? errorMessage,
  }) {
    return Job(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      sourceText: sourceText ?? this.sourceText,
      targetLang: targetLang ?? this.targetLang,
      toneProfile: toneProfile ?? this.toneProfile,
      formatRules: formatRules ?? this.formatRules,
      glossary: glossary ?? this.glossary,
      step1JsonRaw: step1JsonRaw ?? this.step1JsonRaw,
      step2JsonRaw: step2JsonRaw ?? this.step2JsonRaw,
      step3JsonRaw: step3JsonRaw ?? this.step3JsonRaw,
      step1Text: step1Text ?? this.step1Text,
      step2Text: step2Text ?? this.step2Text,
      finalText: finalText ?? this.finalText,
      qaIssues: qaIssues ?? this.qaIssues,
      score: score ?? this.score,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
