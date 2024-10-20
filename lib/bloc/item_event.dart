// Abstract class representing different types of events that can be handled by ItemBloc.
import '../enums/sorting_option.dart';

abstract class ItemEvent {}

// Event to load items from either local storage or from the API.
class LoadItemsEvent extends ItemEvent {}

// Event to search for items based on a search query.
class SearchItemsEvent extends ItemEvent {
  final String searchQuery;

  SearchItemsEvent(this.searchQuery);
}

// Event to sort items based on a selected sorting option.
class SortItemsEvent extends ItemEvent {
  final SortingOption sortingOption;

  SortItemsEvent(this.sortingOption);
}