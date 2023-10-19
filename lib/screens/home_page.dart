import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/providers/products_provider.dart';
import 'package:ecommerce_app/screens/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryIndex = 0;
  String selectedCategory = "All Products";

  final List<String> categories = [
    "All Products",
    "Furniture",
    "Shoes",
    "Others",
    "Clothessss",
    "Electronics",
    "new",
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false).getProductsFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final filteredProducts = selectedCategory == "All Products"
        ? productsProvider.products
        : productsProvider.products
            .where((product) => product.category.name == selectedCategory)
            .toList();
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
                "https://www.apkonline.net/imagescropped/thalapathyvijayhdwallpapericon128.jpg.webp"),
          ),
        ),
        title: const Column(
          children: [
            Row(
              children: [
                Text(
                  "Hello,",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Krishna SN",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications,
              color: Colors.black,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8, 14, 8),
            child: Icon(
              Icons.menu,
              color: Colors.black,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                width: 360,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xfff1f1f1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search for brands",
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: productsProvider.products.take(5).map((product) {
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12),image: DecorationImage(image: NetworkImage(product.images[0]),fit:BoxFit.fill )),
                    // child: Image.network(
                    //   product.images[0],
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == categories[index]
                        ? Colors.black
                        : Colors.grey.withOpacity(0.8),
                  ),
                  child: Text(
                    categories[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              childAspectRatio: 0.76,
            ),
            itemCount: min(20, filteredProducts.length),
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ProductCard(product: product);
            },
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;
  final int maxDescriptionWords;

  ProductCard({required this.product, this.maxDescriptionWords = 20});

  String truncateDescription(String description) {
    final words = description.split(' ');
    if (words.length <= maxDescriptionWords) {
      return description;
    }
    return words.take(maxDescriptionWords).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                    desc: product.description,
                    img: product.images,
                    price: product.price,
                    title: product.title)));
      },
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.7,
            child: Card(
              elevation: 2,
              color: Colors.white,
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.network(
                    product.images[0],
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          product.description,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 35,
                                width: 35,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
