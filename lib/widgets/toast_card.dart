import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/toast.dart';


// Represents a card widget for displaying an item
class ToastCard extends StatelessWidget {
  const ToastCard({
    super.key,
    required this.itemIndex,
    required this.item,
  });

  final int itemIndex; // Index of the item
  final Toast item; // Item to be displayed on the card

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    Size size = MediaQuery.of(context).size;

    // Format the lastSold date of the item
    String formattedLastSold = item.formattedLastSold();

    // Display name of the item
    var itemDisplayName = item.name;

    String price;

    // Check if the currency is "EUR"
    if (item.currency == "EUR") {
      // If the currency is "EUR", append "€" to the price
      price = '${item.price} €';
    } else {
      // If the currency is not "EUR", append the currency to the price
      price = '${item.price} ${item.currency}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      height: 150,
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Container for the card background with shadow
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    blurRadius: 20.0, // soften the shadow
                    offset: const Offset(5.0, 5.0),
                  )
                ],
              ),
            ),
            // Positioned widget for placing content at the bottom of the card
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 140,
                width: size.width - 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Display item name
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: Text(
                        itemDisplayName.trim(),
                        key: const Key("item_name_text"),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Display lastSold date
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: Text(
                        "Last Sold: $formattedLastSold",
                        key: const Key("item_last_sold_text"),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    // Display item price
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: Text(
                        "Price: $price",
                        key: const Key("item_price_text"),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
