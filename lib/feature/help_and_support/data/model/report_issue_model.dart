class ReportIssueRequest {
  final String userId;
  final String vehicleId;
  final String issueType;
  final String issueRelatedTo;
  final String description;
  final String callSlotId;

  ReportIssueRequest({
    required this.userId,
    required this.vehicleId,
    required this.issueType,
    required this.issueRelatedTo,
    required this.description,
    required this.callSlotId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "vehicleId": vehicleId,
      "issueType": issueType,
      "issueRelatedTo": issueRelatedTo,
      "description": description,
      "callSlotId": callSlotId,
    };
  }
}

