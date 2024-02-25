import 'dart:convert';
import 'dart:io';
import 'dart:math';

typedef Predicate = bool Function(Map<String, dynamic>);

//variety of functions to filter and manipulate data from datasets.dart
//only data at the moment is product data
/*
ex. functions in use:

  getFilteredData('sub_category', 'Topwear', ['_id', 'title', 'actual_price']);

  filterProducts('sub_category', 'Topwear', 'products-dataset.json');

  fetchData(products, ['_id', 'title', 'actual_price']);

  generateAndInsertNewNumericalFields(products, 'emission', 50, 100);

  insertNewFieldType(products, String propertyName);

*/

//filter data by ONE property value and a list of field types to display for each product
List<List<Map<String, dynamic>>> getFilteredData(String property, String value, List<String> fieldsToDisplay){
  final String filename = 'products-dataset.json';
  
  final List<Map<String, dynamic>> products = filterProducts(filename, property, value);
  final  List<List<Map<String, dynamic>>> filteredInfo = fetchData(products, fieldsToDisplay);
  return filteredInfo;
}

//returns all products that have the same property value
List<Map<String, dynamic>> filterProducts(String property, String value, String filename) {
  try {
    // Read the contents of the JSON file
    final file = File(filename);
    final contents = file.readAsString();

    // Parse the JSON string into a Dart list of maps
    final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(json.decode(contents as String));

    // Filter products based on the provided property and value
    final List<Map<String, dynamic>> filteredProducts = products.where((product) {
      if (product.containsKey(property) && product[property] == value){
        return product[property] == value;
      } else {
        return false;
      }
    }).toList();

    return filteredProducts;
  } catch (error) {
    print('Error reading JSON file: $error');
    return []; // Return empty list on error
  }
}


List<List<Map<String, dynamic>>> fetchData(List<Map<String, dynamic>> products, List<String> fieldsToDisplay){
  List<List<Map<String, dynamic>>> newProductInfo = [];
  for (var product in products){
    List<Map<String, dynamic>> filteredProperties = [];
    for (var property in fieldsToDisplay){
      filteredProperties.add({property:product[property]});
    }
    newProductInfo.add(filteredProperties);
  }
  return newProductInfo;

}

//add a new field where the value is a randomly generated number within a desired range
//use for making a new field called emissions with randomized values;
List<Map<String, dynamic>> generateAndInsertNewNumericalFields(List<Map<String, dynamic>> products, String propertyName, int min, int max){
   int randomNumber = generateRandomNumber(min, max);
   products.forEach((product) {
    Map<String, dynamic> newMap = { propertyName, randomNumber.toString()} as Map<String, dynamic>;
    products.add(newMap);
  });
  return products;

}

int generateRandomNumber(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max - min + 1);
}

//adds a new field to every product in the data
List<Map<String, dynamic>> insertNewFieldType(List<Map<String, dynamic>> products, String propertyName){
  products.forEach((product) {
    Map<String, dynamic> newMap = { propertyName, null} as Map<String, dynamic>;
    products.add(newMap);
  });
  return products;
}




// Future<void> main() async {
//   final String filename = 'products-dataset.json';
//   final String property = 'sub_category';
//   final String value = 'Topwear';

//   final List<String> fieldsToDisplay = ['_id','title', 'brand', 'actual_price'];

//   final List<Map<String, dynamic>> products = await fetchProductData(filename, property, value);
//   final  List<List<Map<String, dynamic>>> filteredInfo = filterData(products, fieldsToDisplay);

//   if (products.isNotEmpty) {
//     print('Products matching the filter:');
//     filteredInfo.forEach((product) {
//       print(product);
//     });
//   } else {
//     print('No products found matching the filter.');
//   }
// }
