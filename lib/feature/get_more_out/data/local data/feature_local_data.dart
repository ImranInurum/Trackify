import 'package:flutter/material.dart';

class FeatureLocalData {

  //SAFETY
  static List<Map<String,dynamic>> safetyItems =[
    {
      "title": "Geofence Alert",
      "subtitle": "Set your vehicle safe zone.",
      "icon": Icons.location_on_outlined,
    },
    {
      "title": "Overspeed Alert",
      "subtitle": "Get alert on overspeed.",
      "icon": Icons.speed,
    },
    {
      "title": "Safe Parking Alert",
      "subtitle": "Get parking movement alert.",
      "icon": Icons.local_parking_outlined,
    },
    {
      "title": "Emergency SOS",
      "subtitle": "Instant SOS support.",
      "icon": Icons.sos_outlined,
    },
  ];

  //TRACKING

  static List<Map<String,dynamic>>trackingItems =[
    {
      "title": "Live Location Tracking",
      "subtitle": "Track vehicle anytime.",
      "icon": Icons.location_on_outlined,
    },
    {
      "title": "Live Location Sharing",
      "subtitle": "Share live location.",
      "icon": Icons.share_outlined,
    },
    {
      "title": "Navigate to Vehicle",
      "subtitle": "Find parked vehicle.",
      "icon": Icons.map_outlined,
    },
  ];

  //RIDES

  static List<Map<String,dynamic>>rideItems =[
    {
      "title": "Daily Rides & Playback",
      "subtitle": "Replay rides anytime.",
      "icon": Icons.route_outlined,
    },
    {
      "title": "Trips",
      "subtitle": "Manage all trips.",
      "icon": Icons.location_history,
    },
    {
      "title": "Statistics",
      "subtitle": "Track performance.",
      "icon": Icons.bar_chart,
    },
  ];

  //DEVICE
static List<Map<String,dynamic>> deviceItem =[
  {
    "title": "Document Folder",
    "subtitle": "Store important docs.",
    "icon": Icons.folder_outlined,
  },
  {
    "title": "Device Data Plan",
    "subtitle": "Manage device plans.",
    "icon": Icons.sim_card_outlined,
  },
  {
    "title": "Device Warranty",
    "subtitle": "Protect your device.",
    "icon": Icons.security_outlined,
  }
];
}