class ReportIssueRequest {

  final String vehicleId;
  final String issueType;
  final String issueRelatedTo;
  final String description;
  final String callSlotId;

  ReportIssueRequest({
    required this.vehicleId,
    required this.issueType,
    required this.issueRelatedTo,
    required this.description,
    required this.callSlotId,
  });

  Map<String, dynamic> toJson() {

    return {
      "vehicleId": vehicleId,
      "issueType": issueType,
      "issueRelatedTo": issueRelatedTo,
      "description": description,
      "callSlotId": callSlotId,
    };
  }
}

