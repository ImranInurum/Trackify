abstract class UpdateState{}

class UpdateInitial extends UpdateState{}

class UpdateLoading extends UpdateState{}

class UpdateLoaded extends UpdateState{
   final List updates;

   UpdateLoaded(this.updates);
}

class UpdateError extends UpdateState{
  final String message;

  UpdateError(this.message);
}

