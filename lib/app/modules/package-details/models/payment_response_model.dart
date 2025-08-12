class PaymentResponseModel {
  final String paymentId;
  final String status;
  final String message;
  final String transactionId;
  final String paymentUrl;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  PaymentResponseModel({
    required this.paymentId,
    required this.status,
    required this.message,
    required this.transactionId,
    required this.paymentUrl,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.metadata,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      paymentId: json['paymentId'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      transactionId: json['transactionId'] ?? '',
      paymentUrl: json['paymentUrl'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BDT',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'status': status,
      'message': message,
      'transactionId': transactionId,
      'paymentUrl': paymentUrl,
      'amount': amount,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isSuccessful => status.toLowerCase() == 'success' || status.toLowerCase() == 'completed';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed' || status.toLowerCase() == 'error';
}
