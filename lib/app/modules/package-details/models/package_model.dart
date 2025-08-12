import 'payment_response_model.dart';

class PackageModel {
  final String id;
  final String name;
  final String period;
  final double price;
  final String currency;
  final List<String> services;
  final bool isActive;
  final bool isPopular;
  final Map<String, dynamic>? metadata;

  PackageModel({
    required this.id,
    required this.name,
    required this.period,
    required this.price,
    required this.currency,
    required this.services,
    this.isActive = true,
    this.isPopular = false,
    this.metadata,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      period: json['period'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BDT',
      services: List<String>.from(json['services'] ?? []),
      isActive: json['isActive'] ?? true,
      isPopular: json['isPopular'] ?? false,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'period': period,
      'price': price,
      'currency': currency,
      'services': services,
      'isActive': isActive,
      'isPopular': isPopular,
      'metadata': metadata,
    };
  }

  String get formattedPrice => '৳${price.toInt()}';
  String get displayName => name.toUpperCase();
}

class SubscriptionModel {
  final String id;
  final String userId;
  final PackageModel package;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final PaymentResponseModel? lastPayment;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.package,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.lastPayment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      package: PackageModel.fromJson(json['package'] ?? {}),
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      lastPayment: json['lastPayment'] != null 
          ? PaymentResponseModel.fromJson(json['lastPayment'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'package': package.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'lastPayment': lastPayment?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isActive => status.toLowerCase() == 'active' && DateTime.now().isBefore(endDate);
  bool get isExpired => DateTime.now().isAfter(endDate);
  int get daysRemaining => isActive ? endDate.difference(DateTime.now()).inDays : 0;
}
