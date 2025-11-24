// lib/main.dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Detail Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // sizes shown in the UI
  final List<int> sizes = [39, 40, 41, 42, 43, 44];
  int selectedSizeIndex = 2; // preselect 41

  // Use asset image instead of invalid /mnt/data/ path
  final String localImagePath = 'assets/images/mensboots.jpg';

  @override
  Widget build(BuildContext context) {
    final double radius = 24;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: Column(
            children: [
              // Top card with image and back button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Image
                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    localImagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Product brief info
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Men's shoe",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9AA0A6),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Derby Leather",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                                        SizedBox(width: 6),
                                        Text("(4.0)",
                                            style: TextStyle(fontSize: 12, color: Color(0xFF9AA0A6))),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "\$120",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),

                  // Floating back button
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Card(
                      shape: const CircleBorder(),
                      elevation: 4,
                      color: Colors.white,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Size label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Size:',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 8),

              // Sizes
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sizes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final bool selected = index == selectedSizeIndex;
                    return GestureDetector(
                      onTap: () => setState(() => selectedSizeIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 56,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF4C6FFF) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? const Color(0xFF4C6FFF) : const Color(0xFFE6E9EE),
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          sizes[index].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Description area
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    "A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system...",
                    style: TextStyle(fontSize: 13.5, color: Colors.grey[800], height: 1.45),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete"),
                              content: const Text("Delete this item?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text("Deleted")));
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF5A66)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "DELETE",
                          style: TextStyle(color: Color(0xFFFF5A66), fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text("Updated")));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C6FFF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "UPDATE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
