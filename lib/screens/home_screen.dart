import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToCart;

  const HomeScreen({super.key, required this.onNavigateToCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    Provider.of<ProductProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Here...',
                border: InputBorder.none,
                prefixIcon: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: widget.onNavigateToCart,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
        ),
        actions: [
          Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final horizontalPadding = isMobile ? 8.0 : 16.0;
          final verticalPadding = isMobile ? 8.0 : 16.0;

          return RefreshIndicator(
            onRefresh: () => Provider.of<ProductProvider>(context, listen: false).fetchProducts(
              category: Provider.of<ProductProvider>(context, listen: false).selectedCategory,
              sortBy: Provider.of<ProductProvider>(context, listen: false).sortBy,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hero Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/COSRX.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 16),
                        Text(
                          'NEW SKINCARE SERIES',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isMobile ? 4 : 8),
                        Text(
                          'Introducing our revolutionary skincare series, infused with our latest advanced formula for unparalleled results.',
                          style: TextStyle(fontSize: isMobile ? 12 : 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Filtering Options
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Consumer<ProductProvider>(
                            builder: (context, provider, child) {
                              return DropdownButtonFormField<String?>(
                                decoration: const InputDecoration(
                                  labelText: 'Filter by Category',
                                  border: OutlineInputBorder(),
                                ),
                                value: provider.selectedCategory,
                                items: ['All', ...provider.categories].map<DropdownMenuItem<String?>>((category) {
                                  return DropdownMenuItem<String?>(
                                    value: category == 'All' ? null : category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  provider.setSelectedCategory(value);
                                  print('Selected Category: $value');
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: isMobile ? 8 : 16),
                        Expanded(
                          child: Consumer<ProductProvider>(
                            builder: (context, provider, child) {
                              return DropdownButtonFormField<String?>(
                                decoration: const InputDecoration(
                                  labelText: 'Sort by Price',
                                  border: OutlineInputBorder(),
                                ),
                                value: provider.sortBy,
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('None')),
                                  DropdownMenuItem(value: 'asc', child: Text('Price: Low to High')),
                                  DropdownMenuItem(value: 'desc', child: Text('Price: High to Low')),
                                ].toList(),
                                onChanged: (value) {
                                  provider.setSortBy(value);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Grid
                  Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      if (provider.products.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                        itemCount: provider.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 2 : 3,
                          childAspectRatio: isMobile ?   0.95 : 1.1,
                          crossAxisSpacing: isMobile ? 8 : 16,
                          mainAxisSpacing: isMobile ? 8 : 16,
                        ),
                        itemBuilder: (ctx, i) => ProductCard(product: provider.products[i]),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}