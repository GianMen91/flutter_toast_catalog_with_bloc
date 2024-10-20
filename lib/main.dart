import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toast_catalog_with_bloc/screens/item_screen.dart';

import 'bloc/item_bloc.dart';
import 'bloc/item_event.dart';

void main() {
  runApp(
    BlocProvider(
      // Providing the ItemBloc to the widget tree. This makes it available to all descendant widgets.
      create: (context) => ItemBloc()..add(LoadItemsEvent()),  // Creating an instance of ItemBloc and dispatching LoadItemsEvent to load items.
      child: const MyApp(),  // Passing the MyApp widget as the child of BlocProvider.
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Toast Catalog',  // Title of the application, displayed in the app switcher and other places.
        home: ItemScreen(),  // Setting ItemScreen as the home widget, which is the first screen displayed.
        debugShowCheckedModeBanner: false  // Hides the debug banner in the app.
    );
  }
}
