import 'package:bloc/bloc.dart';
import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';
import 'package:trackify/feature/order_summary/domain/usecase/order_summary_usecase.dart';
import 'package:trackify/feature/order_summary/presentation/cubit/order_summary_state.dart';

class OrderSummaryCubit extends Cubit<OrderSummaryState>{

  final GetOrderSummary summary;

  OrderSummaryCubit(this.summary) : super(OrderSummaryInitial());

  Future<void>getPlans ()async {
    emit(OrderSummaryLoading());

    try{
      final plans = await summary();

      emit(OrderSummaryLoaded(
          plans: plans,
          selectedPlans: plans.first
      )
       );

    }catch(e){
      emit(OrderSummaryError(e.toString()));
    }
  }

  void selectPlan(OrderSummaryEntity plan){
    if(state is OrderSummaryLoaded){
      final currentState = state as OrderSummaryLoaded;
      
      emit(OrderSummaryLoaded(
          plans: currentState.plans,
          selectedPlans: plan));
    }
  }
}