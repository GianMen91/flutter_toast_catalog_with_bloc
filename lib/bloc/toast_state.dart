import 'package:equatable/equatable.dart';
import '../models/toast.dart';

class ToastState extends Equatable {
  final bool isLoading;  // Is loading happening?
  final List<Toast> items;  // Loaded toast items.
  final String? errorMessage;  // Potential error messages.

  // Constructor with default values
  const ToastState({
    this.isLoading = false,
    this.items = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, items, errorMessage];

  // CopyWith method to allow partial updates to the state
  ToastState copyWith({
    bool? isLoading,
    List<Toast>? items,
    String? errorMessage,
  }) {
    return ToastState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}
