import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toast_catalog_with_bloc/bloc/item_bloc.dart';
import 'package:flutter_toast_catalog_with_bloc/repository/item_repository.dart';
import 'package:flutter_toast_catalog_with_bloc/view/item_view.dart';

// Entry point of the Toast Catalog App
class ToastCatalogApp extends StatelessWidget {
  const ToastCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of ItemRepository which handles API calls.
    final weatherRepository = ItemRepository();

    return BlocProvider(
      // Initialize the itemBloc using the ItemRepository instance.
      create: (context) => ItemBloc(itemApiCall: weatherRepository),
      // Wrap the widget tree with the WeatherBloc provider, so it can be accessed by any widget in the tree.
      child: const MaterialApp(
        // Disable the debug banner in the app.
        debugShowCheckedModeBanner: false,
        // Set the home screen of the app to be the ItemScreen.
        home: ItemView(),
      ),
    );
  }
}
