import 'package:flutter/material.dart';
import 'package:trackify/feature/help_and_support/data/model/time_slot_model.dart';

class MyIssueModel {
  final String id;
  final String imei;
  final String vehicleNumber;
  final String issueType;
  final String issueRelatedTo;
  final String description;
  final String issueStatus;
  final Color? statusColor;
  final TimeSlotModel? callSlot;
  final DateTime createdAt;

  MyIssueModel({
    required this.id,
    required this.imei,
    required this.vehicleNumber,
    required this.issueType,
    required this.issueRelatedTo,
    required this.description,
    required this.issueStatus,
    this.statusColor,
    required this.callSlot,
    required this.createdAt,
  });

  String get slotDate => callSlot?.dateText ?? '';

  factory MyIssueModel.fromJson(Map<String, dynamic> json) {
    Color? parsedColor;
    if (json['statusColor'] != null && json['statusColor'].toString().isNotEmpty) {
      try {
        String colorStr = json['statusColor'].toString().replaceAll('#', '');
        if (colorStr.length == 6) {
          colorStr = 'FF' + colorStr;
        }
        parsedColor = Color(int.parse('0x' + colorStr));
      } catch (e) {
        // Fallback or ignore
      }
    }

    return MyIssueModel(
      id: json['_id'] ?? '',
      imei: json['vehicleId'] ?? json['imei'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      issueType: json['issueType'] ?? '',
      issueRelatedTo: json['issueRelatedTo'] ?? '',
      description: json['description'] ?? '',
      issueStatus: json['issueStatus'] ?? '',
      statusColor: parsedColor,
      callSlot: json['callSlot'] != null ? TimeSlotModel.fromJson(json['callSlot']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}