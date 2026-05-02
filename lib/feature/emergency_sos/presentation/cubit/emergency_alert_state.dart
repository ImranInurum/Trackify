abstract class EmergencyAlertState {}

class EmergencyAlertIntial extends EmergencyAlertState{}

class EmergencySending extends EmergencyAlertState{}

class  EmergencySent extends EmergencyAlertState{
  final String  message;

  EmergencySent(this.message);
}

class EmergencyError extends EmergencyAlertState{
  final String message;

  EmergencyError(this.message);
}

class EmergencyTimerTick extends EmergencyAlertState{
  final  int second;

  EmergencyTimerTick(this.second);
}