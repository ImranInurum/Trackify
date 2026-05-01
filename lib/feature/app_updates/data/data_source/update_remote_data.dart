import '../model/update_model.dart';

class UpdateRemoteDataSource {
  Future<List<UpdateModel>> getUpdates() async {
    await Future.delayed(Duration(seconds: 1));

    return [
      UpdateModel(
        date: "September 17, 2025",
        version: "19.1.0",
        titles: ["🪔 Happy Diwali!"],
        descriptions: [
          "We've fixed some bugs and made the app smoother."
        ],
      ),
      UpdateModel(
        date: "September 8, 2025",
        version: "19.0.10",
        titles: ["✨ Several improvements"],
        descriptions: [
          "We've made several improvements throughout the app."
        ],
      ),
    ];
  }
}