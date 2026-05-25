class MySuggestionModel {
  final String id;
  final String userId;
  final String suggestionType;
  final String subject;
  final String description;
  final String status;
  final DateTime createdAt;

  MySuggestionModel({
    required this.id,
    required this.userId,
    required this.suggestionType,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory MySuggestionModel.fromJson(Map<String, dynamic> json) {
    return MySuggestionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      suggestionType: json['suggestionType'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['issueStatus'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class SuggestionRequest {
  final String userId;
  final String suggestionType;
  final String subject;
  final String description;

  SuggestionRequest({
    required this.userId,
    required this.suggestionType,
    required this.subject,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "suggestionType": suggestionType,
      "subject": subject,
      "description": description,
    };
  }
}