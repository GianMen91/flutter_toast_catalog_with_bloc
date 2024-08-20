import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Item {
  final int id;
  final String name;
  final double price;
  final String currency;
  final DateTime lastSold;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.lastSold,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      currency: json['currency'] ?? '',
      lastSold: _parseDateTime(json['lastSold']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'lastSold': lastSold.toIso8601String(),
    };
  }

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      try {
        return double.parse(value);
      } on Exception catch (e) {
        print("Error parsing double from string: $e");
      }
    }
    return 0.0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } on Exception catch (e) {
        if (kDebugMode) {
          print("Error parsing DateTime from string: $e");
        }
      }
    }
    return DateTime.now();
  }

  String formattedLastSold() {
    return DateFormat('dd MMMM yyyy').format(lastSold);
  }
}
