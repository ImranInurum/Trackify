class HealthInsuranceLocalDataSource{

  Future<Map<String,dynamic>>getHealthInsuranceData()async{
    await Future.delayed(Duration(seconds: 1));

    return {
      "bloodGroup":[
        "A+",
        "A-",
        "B+",
        "B-",
        "AB+",
        "AB-",
        "O+",
        "O-",
        "Don't know",
      ],

    };
  }
}