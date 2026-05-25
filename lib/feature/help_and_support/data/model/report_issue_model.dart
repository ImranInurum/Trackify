class ReportIssueRequest {
  final String userId;
  final String imei;
  final String issueType;
  final String issueRelatedTo;
  final String description;
  final String callSlotId;

  ReportIssueRequest({
    required this.userId,
    required this.imei,
    required this.issueType,
    required this.issueRelatedTo,
    required this.description,
    required this.callSlotId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "imei": imei,
      "issueType": issueType,
      "issueRelatedTo": issueRelatedTo,
      "description": description,
      "callSlotId": callSlotId,
    };
  }
}

