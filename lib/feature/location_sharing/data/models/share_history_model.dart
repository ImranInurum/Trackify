class ShareHistoryItem {
  final String shareId;
  final String token;
  final String shareType;
  final String status;
  final String webLink;
  final String imei;
  final String? sharedWithUserId;
  final DateTime? expiresAt;
  final int expiresInHours;
  final DateTime? stoppedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final int viewCount; // the API doesn't seem to return view count, but the UI shows an eye icon with "0"

  ShareHistoryItem({
    required this.shareId,
    required this.token,
    required this.shareType,
    required this.status,
    required this.webLink,
    required this.imei,
    this.sharedWithUserId,
    this.expiresAt,
    required this.expiresInHours,
    this.stoppedAt,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.viewCount = 0,
  });

  factory ShareHistoryItem.fromJson(Map<String, dynamic> json) {
    int calculatedHours = json['expiresInHours'] ?? 0;
    
    // Fallback: Calculate hours from expiresAt and startDate if expiresInHours is 0
    if (calculatedHours == 0 && json['expiresAt'] != null && json['startDate'] != null) {
      final expires = DateTime.parse(json['expiresAt']);
      final start = DateTime.parse(json['startDate']);
      calculatedHours = (expires.difference(start).inMinutes / 60.0).round();
      if (calculatedHours < 0) calculatedHours = 0; // Prevent negative hours
    }

    return ShareHistoryItem(
      shareId: json['shareId'] ?? '',
      token: json['token'] ?? '',
      shareType: json['shareType'] ?? '',
      status: json['status'] ?? '',
      webLink: json['webLink'] ?? '',
      imei: json['imei'] ?? '',
      sharedWithUserId: json['sharedWithUserId'],
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      expiresInHours: calculatedHours,
      stoppedAt: json['stoppedAt'] != null ? DateTime.parse(json['stoppedAt']) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      viewCount: json['viewCount'] ?? 0,
    );
  }
}
