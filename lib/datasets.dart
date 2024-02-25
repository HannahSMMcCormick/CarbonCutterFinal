import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchProductData(String keywords) async {
  final String url = 'https://amazon-pricing-and-product-info.p.rapidapi.com/';
  final Map<String, String> queryParams = {
    'keywords': keywords,
    'domain': 'de',
  };
  final Map<String, String> headers = {
    'X-RapidAPI-Key': '78ba902980msh98339935fad99adp12706fjsn4cb7c296161d',
    'X-RapidAPI-Host': 'amazon-pricing-and-product-info.p.rapidapi.com',
  };

  final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

  try {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      print('Failed to load data: ${response.statusCode}');
      return {}; // Return empty map on failure
    }
  } catch (error) {
    print('Error: $error');
    return {}; // Return empty map on error
  }
}

void main() async {
    final keywords = 'purse';
    final productData = await fetchProductData(keywords);
    print(productData);
}