import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:historia/provider/theme_provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String collectionName;
  final String title;
  final Color accentColor;

  const CategoryDetailScreen({
    Key? key,
    required this.collectionName,
    required this.title,
    this.accentColor = const Color(0xFF5D69BE),
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _items = [];
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  bool _isLoading = true;
  final Set<String> _favorites = {};
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {
    try {
      final snapshot = await _firestore.collection(widget.collectionName).get();
      setState(() {
        _items = snapshot.docs;
        _isLoading = false;
      });
      if (_items.isNotEmpty) {
        _animationController.forward();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load content: ${e.toString()}')),
      );
    }
  }

  void _shareContent(String title, String description, String imageUrl) {
    final text = '📚 $title | Historia App\n\n$description\n\nLearn more historical facts on Historia!';
    Share.share(text);
  }

  void _toggleFavorite(String itemId) {
    setState(() {
      if (_favorites.contains(itemId)) {
        _favorites.remove(itemId);
      } else {
        _favorites.add(itemId);
      }
    });
    // Here you would save to persistent storage or user profile
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeMode == ThemeMode.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.document_text_outline,
              size: 72,
              color: textColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      )
          : Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                _animationController.reset();
                _animationController.forward();
              });
            },
            itemBuilder: (context, index) {
              final item = _items[index].data() as Map<String, dynamic>;
              final itemId = _items[index].id;
              final isFavorite = _favorites.contains(itemId);

              return FadeTransition(
                opacity: _animationController,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: [0.6, 1.0],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: CachedNetworkImage(
                                imageUrl: item['imageLink'] ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: widget.accentColor.withOpacity(0.1),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: widget.accentColor,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: widget.accentColor.withOpacity(0.1),
                                  child: Icon(
                                    Ionicons.image_outline,
                                    color: widget.accentColor,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                            // Floating badges for time period
                            if (item['period'] != null)
                              Positioned(
                                top: 100,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.accentColor.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item['period'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Content area
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'],
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Ionicons.bookmark
                                          : Ionicons.bookmark_outline,
                                      color: isFavorite ? widget.accentColor : textColor,
                                    ),
                                    onPressed: () => _toggleFavorite(itemId),
                                  ),
                                ],
                              ),
                            ),

                            // Location/Category Tag
                            if (item['location'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Ionicons.location_outline,
                                      size: 16,
                                      color: widget.accentColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item['location'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Main description
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                item['description'],
                                style: GoogleFonts.merriweather(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: textColor,
                                ),
                              ),
                            ),

                            // Additional facts section
                            if (item['facts'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Key Facts',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...(item['facts'] as List).map((fact) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Ionicons.chevron_forward_circle,
                                              color: widget.accentColor,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                fact,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  height: 1.6,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),

                            // References/Sources
                            if (item['source'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: textColor.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Source',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['source'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            // Bottom spacing for page indicator
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withOpacity(0),
                    backgroundColor,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _items.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: widget.accentColor,
                      dotColor: textColor.withOpacity(0.2),
                    ),
                  ),

                  // Share button
                  FloatingActionButton(
                    heroTag: "shareBtn",
                    mini: true,
                    backgroundColor: widget.accentColor,
                    onPressed: () {
                      final item = _items[_currentPage].data() as Map<String, dynamic>;
                      _shareContent(
                          item['title'],
                          item['description'],
                          item['imageLink'] ?? ''
                      );
                    },
                    child: const Icon(Icons.share, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}