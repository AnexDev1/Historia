import 'package:flutter/material.dart';
import 'package:historia/components/drawer_widget.dart';
import 'package:historia/screens/auth/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:historia/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import 'category_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late ThemeMode currentThemeMode;
  String userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Explorer';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    currentThemeMode = Provider.of<ThemeProvider>(context, listen: false).currentThemeMode;

    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: currentThemeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout Failed'),
            content: const Text('An error occurred while logging out. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Places',
      'description': 'Historic landmarks and architecture',
      'icon': Ionicons.location,
      'color': const Color(0xFF5D69BE),
      'collectionName': 'places',
    },
    {
      'title': 'Peoples',
      'description': 'Notable historical figures',
      'icon': Ionicons.people,
      'color': const Color(0xFFE17B77),
      'collectionName': 'peoples',
    },
    {
      'title': 'Animals',
      'description': 'Native and significant fauna',
      'icon': Ionicons.paw,
      'color': const Color(0xFF61B15A),
      'collectionName': 'animals',
    },
    {
      'title': 'Foods',
      'description': 'Traditional cuisine and dishes',
      'icon': Ionicons.restaurant,
      'color': const Color(0xFFFFB26B),
      'collectionName': 'foods',
    },
    {
      'title': 'Cultures',
      'description': 'Traditions, languages, and customs',
      'icon': Ionicons.globe,
      'color': const Color(0xFF9B5DE5),
      'collectionName': 'cultures',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = currentThemeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.amber[700] : const Color(0xFF76323F);
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      drawer: AppDrawer(context: context, userName: userName),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/heritage_banner.jpg', // Add this image to your assets
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $userName',
                          style: GoogleFonts.lora(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore Heritage',
                          style: GoogleFonts.playfairDisplay(
                            textStyle: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Ionicons.menu_outline, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Ionicons.search_outline, color: Colors.white),
                onPressed: () {
                  // Implement search functionality
                },
              ),
              IconButton(
                icon: const Icon(Ionicons.log_out_outline, color: Colors.white),
                onPressed: _logout,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.lora(
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // View all categories
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    title: category['title'],
                    description: category['description'],
                    icon: category['icon'],
                    color: category['color'],
                    cardColor: cardColor,
                    textColor: textColor,
                    secondaryTextColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(
                            collectionName: category['collectionName'],
                            title: category['title'],
                          ),
                        ),
                      );
                    },
                    animation: _animationController,
                    delay: index * 0.2,
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                'Featured Stories',
                style: GoogleFonts.lora(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return FeaturedStoryCard(
                    cardColor: cardColor,
                    textColor: textColor,
                    secondaryTextColor: Colors.black,
                    index: index,
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onTap;
  final AnimationController animation;
  final double delay;

  const CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onTap,
    required this.animation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animValue = CurvedAnimation(
          parent: animation,
          curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
        ).value;

        return Transform.scale(
          scale: 0.6 + (0.4 * animValue),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.lora(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Ionicons.chevron_forward, size: 18, color: color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturedStoryCard extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final int index;

  const FeaturedStoryCard({
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final images = [
      'assets/place.jpg',
      'assets/people.jpg',
      'assets/culture.jpg',
      'assets/food.jpg',
      'assets/animal.jpg',
    ];

    final titles = [
      'The Forgotten Temple',
      'Legacy of Queen Amina',
      'Festival of Lights',
      'Ancient Spice Routes',
      'Sacred Animals',
    ];

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                images[index % images.length],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titles[index % titles.length],
                    style: GoogleFonts.playfairDisplay(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Ionicons.time_outline, size: 14, color: secondaryTextColor),
                      const SizedBox(width: 4),
                      Text(
                        '5 min read',
                        style: TextStyle(fontSize: 12, color: secondaryTextColor),
                      ),
                      const Spacer(),
                      Icon(Ionicons.bookmark_outline, size: 18, color: secondaryTextColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}