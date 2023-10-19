import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier {
  static const apiProduct = "https://api.escuelajs.co/api/v1/products";
  static const apiCategories = "https://api.escuelajs.co/api/v1/categories";
  bool isLoadingProducts = true;
  bool isLoadingCategories = true;
  String errorProducts = '';
  String errorCategories = '';
  List<Products> products = [];
  List<Category> categories = [];
  Category? _selectedCategory;

  Category? get selectedCategory => _selectedCategory;

  set selectedCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> getProductsFromAPI() async {
    try {
      final response = await http.get(Uri.parse(apiProduct));
      if (response.statusCode == 200) {
        final List<dynamic> productsData = json.decode(response.body);
        products = productsData.map((data) => Products.fromJson(data)).toList();
        isLoadingProducts = false;
        errorProducts = '';
      } else {
        errorProducts = 'Failed to fetch product data';
        isLoadingProducts = false;
      }
    } catch (e) {
      errorProducts = 'An error occurred while fetching product data.';
      isLoadingProducts = false;
    }
    notifyListeners();
  }
}
