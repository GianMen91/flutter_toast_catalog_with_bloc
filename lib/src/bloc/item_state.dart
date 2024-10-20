// Abstract class representing different states of the ItemBloc.
import '../models/item.dart';

abstract class ItemState {}

// State indicating that items are currently being loaded.
class ItemsLoading extends ItemState {}

// State representing that items have been successfully loaded.
class ItemsLoaded extends ItemState {
  final List<Item> items;

  ItemsLoaded(this.items);
}

// State representing an error occurred while loading items.
class ItemsError extends ItemState {
  final String message;

  ItemsError(this.message);
}