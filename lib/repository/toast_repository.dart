import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/toast.dart';

class ToastRepository {

  static const apiURL =  // URL to fetch items from an external API.
      'https://gist.githubusercontent.com/GianMen91/0f93444fade28f5755479464945a7ad1/raw/f7ad7a60b2cff021ecf6cf097add060b39a1742b/toast_list.json';

  // Fetch items from the API and store them in local storage.
  Future<List<Toast>> fetchToastList() async {
    try {
      http.Response response = await http.get(Uri.parse(apiURL));  // Make an HTTP GET request to the API.

      if (response.statusCode == 200) {
        String responseResult = response.body;  // Get the response body as a string.
        return _getListFromData(responseResult);  // Parse the response data into a list of items.
      } else {
        throw Exception('Error occurred');  // Throw an exception if the API response status is not OK.
      }
    } on SocketException {
      throw Exception(
          'Impossible to download the items from the server.\n'
              'Check your internet connection and retry!');
      // Throw an exception if there is a network error.
    }
  }

  // Convert JSON response to a list of Item objects.
  List<Toast> _getListFromData(String response) {
    final Map<String, dynamic> responseData = json.decode(response);  // Decode the JSON response.
    final List<dynamic> items = responseData['items'];  // Extract the list of items from the response.
    return items.map((item) => Toast.fromJson(item)).toList();  // Convert each item to an Item object and return the list.
  }

}
