import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/plus_membership_model.dart';

abstract class PlusMembershipRemoteDataSource {

  Future<PlusMembershipModel>
  getPlusMembershipDetails();

  Future<void> upgradeToPlus();
}

class PlusMembershipRemoteDataSourceImpl
    implements PlusMembershipRemoteDataSource {

  final String baseUrl;

  PlusMembershipRemoteDataSourceImpl({
    required this.baseUrl,
  });

  @override
  Future<PlusMembershipModel>
  getPlusMembershipDetails() async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/api/plus-membership/plus-plan",
      ),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return PlusMembershipModel.fromJson(data);
    }

    throw Exception(
      "Failed to load plus membership: ${response.statusCode} ${response.reasonPhrase}",
    );
  }

  @override
  Future<void> upgradeToPlus() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }
}