import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Represents an item with specific properties
class Toast {
  final int id; // Unique identifier for the item
  final String name; // Name of the item
  final double price; // Price of the item
  final String currency; // Currency in which the item's price is expressed
  final DateTime lastSold; // Date and time when the item was last sold

  // Constructor to initialize an Item instance with required properties
  Toast({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.lastSold,
  });

  factory Toast.fromJson(Map<String, dynamic> json) {
    return Toast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      currency: json['currency'] ?? '',
      lastSold: _parseDateTime(json['last_sold']),
    );
  }


  // Constructor to create an empty Item instance with default values
  Toast.empty()
      : id = 0,
        name = '',
        price = 0.0,
        currency = '',
        lastSold = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'lastSold': lastSold.toIso8601String(),
    };
  }

  // Updated _parseDouble
  static double _parseDouble(dynamic value) {
    if (value is double) return value;  // Directly return if already double
    if (value is int) return value.toDouble();  // Convert int to double
    if (value is String) {
      try {
        return double.parse(value);
      } on Exception catch (e) {
        if (kDebugMode) {
          print("Error parsing double from string: $e");
        }
      }
    }
    return 0.0;  // Return default if parsing fails
  }

// Updated _parseDateTime
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
    return DateTime.now();  // Return now if parsing fails
  }


  // Method to format the lastSold date as a string in a specific format
  String formattedLastSold() {
    return DateFormat('dd MMMM yyyy').format(lastSold);
  }
}
