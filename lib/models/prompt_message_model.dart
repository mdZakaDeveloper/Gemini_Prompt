import 'dart:convert';

class PromptMessageModel {
  final String role;
  final List<PromptPartModel> parts;

  PromptMessageModel({required this.role, required this.parts});

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'parts': parts.map((x) => x.toMap()).toList(),
    };
  }

  factory PromptMessageModel.fromMap(Map<String, dynamic> map) {
    return PromptMessageModel(
      role: map['role'] ?? '',
      parts: List<PromptPartModel>.from(map['parts']?.map((x) => PromptPartModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromptMessageModel.fromJson(String source) => PromptMessageModel.fromMap(json.decode(source));
}

class PromptPartModel {
  final String text;

  PromptPartModel({required this.text});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  factory PromptPartModel.fromMap(Map<String, dynamic> map) {
    return PromptPartModel(
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PromptPartModel.fromJson(String source) => PromptPartModel.fromMap(json.decode(source));
}
