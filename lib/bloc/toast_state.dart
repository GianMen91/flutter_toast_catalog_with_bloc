// Abstract class representing different states of the ItemBloc.
import '../models/toast.dart';

abstract class ToastState {}

// State indicating that items are currently being loaded.
class ToastLoading extends ToastState {}

// State representing that items have been successfully loaded.
class ItemsLoaded extends ToastState {
  final List<Toast> items;

  ItemsLoaded(this.items);
}

// State representing an error occurred while loading items.
class ItemsError extends ToastState {
  final String message;

  ItemsError(this.message);
}