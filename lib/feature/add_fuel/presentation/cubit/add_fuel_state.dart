abstract class AddFuelState{}

class AddFuelInitial extends AddFuelState{}

class AddFuelLoading  extends AddFuelState{}

class AddFuelSuccess extends AddFuelState{}

class AddFuelError extends AddFuelState{
  final message;

  AddFuelError(this.message);
}