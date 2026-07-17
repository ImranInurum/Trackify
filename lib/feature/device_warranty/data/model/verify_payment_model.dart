import 'package:equatable/equatable.dart';

class VerifyPaymentRequest extends Equatable {
  final String razorpayOrderId;
  final String razorpayPaymentId;

  const VerifyPaymentRequest({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
    };
  }

  @override
  List<Object?> get props => [razorpayOrderId, razorpayPaymentId];
}
