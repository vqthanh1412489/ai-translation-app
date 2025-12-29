class AgentConfig {
  final String name; // "Translator" | "Stylist" | "QA"
  final String model;
  final double temperature;
  final int maxTokens;
  final String systemPrompt;
  final String userPromptTemplate;

  AgentConfig({
    required this.name,
    required this.model,
    required this.temperature,
    required this.maxTokens,
    required this.systemPrompt,
    required this.userPromptTemplate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'model': model,
      'temperature': temperature,
      'maxTokens': maxTokens,
      'systemPrompt': systemPrompt,
      'userPromptTemplate': userPromptTemplate,
    };
  }

  factory AgentConfig.fromJson(Map<String, dynamic> json) {
    return AgentConfig(
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      temperature: (json['temperature'] ?? 0.7).toDouble(),
      maxTokens: json['maxTokens'] ?? 2000,
      systemPrompt: json['systemPrompt'] ?? '',
      userPromptTemplate: json['userPromptTemplate'] ?? '',
    );
  }

  AgentConfig copyWith({
    String? name,
    String? model,
    double? temperature,
    int? maxTokens,
    String? systemPrompt,
    String? userPromptTemplate,
  }) {
    return AgentConfig(
      name: name ?? this.name,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      userPromptTemplate: userPromptTemplate ?? this.userPromptTemplate,
    );
  }
}
