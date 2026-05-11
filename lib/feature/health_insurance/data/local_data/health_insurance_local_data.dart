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

      "insuranceList":[
        "Star Health Insurance",
        "HDFC ERGO General Insurance",
        "ICICI Lombard General Insurance",
        "Niva Bupa Health Insurance",
        "Bajaj Allianz General Insurance",
        "Care Health Insurance",
        "Reliance General Insurance",
        "SBI Health Insurance",
        "Tata AIG General Insurance",
        "Kotak Health Insurance",
        "Aditya Birla Health Insurance",
        "ManipalCigna Health Insurance",
        "New India Assurance",
        "United India Insurance",
        "National Insurance Company",
        "Oriental Insurance Company",
        "I don't have insurance",
      ]
    };
  }
}