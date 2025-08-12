class PaymentRequestModel {
  final String packageId;
  final String packageName;
  final String period;
  final double amount;
  final String paymentMethod;
  final String currency;
  final String userId;

  PaymentRequestModel({
    required this.packageId,
    required this.packageName,
    required this.period,
    required this.amount,
    required this.paymentMethod,
    required this.currency,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'packageName': packageName,
      'period': period,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'currency': currency,
      'userId': userId,
    };
  }

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      packageId: json['packageId'] ?? '',
      packageName: json['packageName'] ?? '',
      period: json['period'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      currency: json['currency'] ?? 'BDT',
      userId: json['userId'] ?? '',
    );
  }
}
