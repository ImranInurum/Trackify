import '../model/plus_membership_model.dart';

abstract class PlusMembershipRemoteDataSource {
  Future<PlusMembershipModel> getPlusMembershipDetails();
  Future<void> upgradeToPlus();
}

class PlusMembershipRemoteDataSourceImpl implements PlusMembershipRemoteDataSource {
  @override
  Future<PlusMembershipModel> getPlusMembershipDetails() async {
    // Simulated API response based on the UI requirement
    await Future.delayed(const Duration(milliseconds: 800));
    
    return PlusMembershipModel(
      currentPrice: 709,
      originalPrice: 3099,
      duration: "for 1 year",
      usersCountMessage: "99 users bought plus yesterday",
      premiumBenefits: const [
        PremiumBenefitModel(
          title: "Top Speed",
          subtitle: "Check your vehicle's top speed for rides and stats of all date range.",
          iconType: "speed",
        ),
        PremiumBenefitModel(
          title: "Custom Vehicle Icons",
          subtitle: "Customize your vehicle icon on the map. Choose a unique look to match your vehicle style.",
          iconType: "car",
        ),
        PremiumBenefitModel(
          title: "Safe Parking",
          subtitle: "Receive ignition & motion alerts via call when your vehicle is parked (Only for Trackify Lite and Trackify Pro users).",
          iconType: "parking",
        ),
        PremiumBenefitModel(
          title: "Detailed Statistics",
          subtitle: "Includes the graphical representations of data in more detailed manner",
          iconType: "stats",
        ),
      ],
      otherBenefits: const [
        OtherBenefitModel(
          title: "Geofence SMS Alert",
          description: "Get SMS alerts for vehicles entering/exiting the geo-fence.",
          regularValue: "Check",
          plusValue: "4/day",
        ),
        OtherBenefitModel(
          title: "Priority Customer Support",
          description: "Enjoy faster complain resolutions and priority service.",
          regularValue: "Check",
          plusValue: "CheckGold",
        ),
        OtherBenefitModel(
          title: "Past Ride History",
          description: "Past rides backup on Trackify cloud.",
          regularValue: "1 month",
          plusValue: "3 months",
        ),
        OtherBenefitModel(
          title: "Max device mapping limit",
          description: "Maximum number of Trackify device that can be added.",
          regularValue: "3",
          plusValue: "20",
        ),
      ],
      reviews: const [
        PlusReviewModel(
          name: "Akash Patel",
          duration: "Trackify user since 4 years",
          review: "\"Safe Parking feature actually saved me from worrying about my parked bike. Totally worth it!\"",
        ),
        PlusReviewModel(
          name: "Kavya Gupta",
          duration: "Trackify user since 3 years",
          review: "\"I always worried about parking my bike, but Safe Parking notifications help me sleep better now.\"",
        ),
        PlusReviewModel(
          name: "Aditya Joshi",
          duration: "Trackify user since 6 years",
          review: "\"Had a parking mishap last month, but the Safe Parking alert notified me in time. Love this feature!\"",
        ),
        PlusReviewModel(
          name: "Ishita Rao",
          duration: "Trackify user since 3 years",
          review: "\"Vehicle icons are cool. Makes it easier to identify my vehicle, especially when managing multiple ones.\"",
        ),

      ],
    );
  }

  @override
  Future<void> upgradeToPlus() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
