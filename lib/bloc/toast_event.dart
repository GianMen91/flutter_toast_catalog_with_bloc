// Abstract class representing different types of events that can be handled by ItemBloc.
import '../enums/sorting_option.dart';

abstract class ToastEvent {}

// Event to load items from either local storage or from the API.
class FetchToastEvent extends ToastEvent {}

// Event to search for items based on a search query.
class SearchToastEvent extends ToastEvent {
  final String searchQuery;

  SearchToastEvent(this.searchQuery);
}

// Event to sort items based on a selected sorting option.
class SortToastEvent extends ToastEvent {
  final SortingOption sortingOption;

  SortToastEvent(this.sortingOption);
}