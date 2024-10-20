// Abstract class representing different types of events that can be handled by ItemBloc.
import '../enums/sorting_option.dart';

abstract class ToastEvent {}

// Event to load items from either local storage or from the API.
class LoadItemsEvent extends ToastEvent {}

// Event to search for items based on a search query.
class SearchItemsEvent extends ToastEvent {
  final String searchQuery;

  SearchItemsEvent(this.searchQuery);
}

// Event to sort items based on a selected sorting option.
class SortItemsEvent extends ToastEvent {
  final SortingOption sortingOption;

  SortItemsEvent(this.sortingOption);
}