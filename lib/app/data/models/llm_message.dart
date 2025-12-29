class LlmMessage {
  final String role; // "system" | "user" | "assistant"
  final String content;

  LlmMessage({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory LlmMessage.fromJson(Map<String, dynamic> json) {
    return LlmMessage(
      role: json['role'] ?? '',
      content: json['content'] ?? '',
    );
  }

  LlmMessage copyWith({
    String? role,
    String? content,
  }) {
    return LlmMessage(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }
}
