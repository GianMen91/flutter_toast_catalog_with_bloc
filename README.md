# Toast Catalog using BLoC and sqflite

## Overview

This project is based on https://github.com/GianMen91/flutter_toast_catalog, but it has been redeveloped using BLoC and sqflite.

It features a toast catalog created in Flutter that displays a dynamic list of toasts fetched from the external API :
https://gist.githubusercontent.com/GianMen91/0f93444fade28f5755479464945a7ad1/raw/f7ad7a60b2cff021ecf6cf097add060b39a1742b/toast_list.json.

The app allows users to explore, sort, and search through items in an intuitive and user-friendly interface.

## Screenshots

<img src="img/img-1.png" width=300 /> <img src="img/img-2.png" width=300 /> 
<img src="img/img-3.png" width=300 /> 

## Features

- **Item Management**: Easily manage and display a list of items fetched from an external API.
- **Sorting Options**: Sort items by name, last sold date, or price.
- **Search Functionality**: Quickly find items using the search box.
- **Offline Support**: Items are stored locally for seamless offline access.
- **API Integration**: Connects to an external API to fetch the latest item data.
- **Connection Status Check**: Dynamically assesses internet connectivity, providing an error notification if unable to connect to the server.
- **Fallback to Offline Mode**: In the absence of a connection, the app intelligently switches to displaying items from the offline list.
- **Custom Fonts**: Enhance the visual appeal with the Niconne custom font.

## Content Attribution

- **Font (Niconne)**: Used the Niconne font, which is available on [Google Fonts](https://fonts.google.com/specimen/Niconne?preview.text=Good%20morning&query=Vernon+Adams&classification=Handwriting). The font was designed by Vernon Adams.

## Technologies Used
- **Flutter**: Framework for building natively compiled applications.
- **Dart**: Language used to build Flutter applications.
- **HTTP Package**: Used for making HTTP requests to download item data.
- **Linting**: The codebase adheres to best practices and coding standards using lint rules.
- **Widget Tests**: Extensive use of widget tests to ensure the robustness of the UI components, behaviors, and overall application functionality.
- **BLoC**: Business Logic Component pattern for state management, providing a clear separation between business logic and UI.
- **sqflite**: SQLite plugin for Flutter used for local database storage.

## Responsiveness

The app is designed to work seamlessly across various screen sizes, providing a consistent and enjoyable experience on both small and large devices.

## API Connection
Toast Catalog connects seamlessly to an external API to fetch real-time data, ensuring that users have access to the latest information.

