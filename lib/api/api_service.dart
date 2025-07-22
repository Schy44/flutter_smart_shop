import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<Product>> getProducts({String? category, String? sortBy}) async {
    try {
      String url = kProductsUrl;
      Map<String, String> queryParams = {};

      if (category != null && category != 'All') {
        queryParams['category'] = category;
      }
      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
      }

      if (queryParams.isNotEmpty) {
        url = Uri.parse(url).replace(queryParameters: queryParams).toString();
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Raw API Response Body: ${response.body}');
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print('API Error: ${response.statusCode}, Body: ${response.body}');
        throw HttpException('Failed to load products: ${response.statusCode}, body: ${response.body}');
      }
    } on SocketException catch (e) {
      throw SocketException('No Internet connection: $e');
    } on HttpException catch (e) {
      throw HttpException('HttpException: $e');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(kCategoriesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => json['name'] as String).toList();
      } else {
        throw HttpException('Failed to load categories: ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('No Internet connection');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}
