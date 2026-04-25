import 'package:flutter/material.dart';
import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/home/data/home_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  final TextEditingController _searchController = TextEditingController();
  final HomeService _homeService = HomeService();
  bool _isSearching = false;
  bool _isLoadingResults = false;
  String? _searchError;
  List<Map<String, dynamic>> _tourResults = [];
  int _requestCounter = 0;
  
  // Filter state
  bool _isGuidesTab = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final text = _searchController.text.trim();
      if (text.isNotEmpty) {
        _fetchSearchResults(text);
      } else {
        setState(() {
          _tourResults = [];
          _searchError = null;
        });
      }
      setState(() {
        _isSearching = text.isNotEmpty;
      });
    });
  }

  Future<void> _fetchSearchResults(String keyword) async {
    final int requestId = ++_requestCounter;
    setState(() {
      _isLoadingResults = true;
      _searchError = null;
    });

    try {
      final tours = await _homeService.searchTours(keyword: keyword, limit: 20);
      if (!mounted || requestId != _requestCounter) return;
      setState(() {
        _tourResults = tours;
      });
    } on ApiException catch (error) {
      if (!mounted || requestId != _requestCounter) return;
      setState(() {
        _searchError = error.message;
      });
    } finally {
      if (mounted && requestId == _requestCounter) {
        setState(() {
          _isLoadingResults = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Very light background 
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchHeader(),
            const SizedBox(height: 25),
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Where you want to explore",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (_isSearching) ...[
            GestureDetector(
              onTap: () {
                _searchController.clear();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () => _showFiltersBottomSheet(context),
              child: const Icon(Icons.tune, color: Colors.black54),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular destinations",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildPopularChip("Danang, Vietnam"),
            _buildPopularChip("Ho Chi Minh, Vietnam"),
            _buildPopularChip("Venice, Italy"),
          ],
        )
      ],
    );
  }

  Widget _buildPopularChip(String text) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoadingResults) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchError != null) {
      return Center(
        child: Text(
          _searchError!,
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_tourResults.isEmpty) {
      return const Center(
        child: Text(
          "No tours found for this keyword",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tours (${_tourResults.length})",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "SEE MORE",
                style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ..._tourResults.map((tour) {
            final title = tour["title"]?.toString() ?? "Untitled Tour";
            final location = tour["location"]?.toString() ?? "Unknown";
            final price = tour["priceFrom"];
            final num? priceNum = price is num ? price : num.tryParse(price?.toString() ?? "");
            final displayPrice = "\$${(priceNum ?? 0).toStringAsFixed(2)}";
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildTourCard(title, "assets/icons/dbh2.png", displayPrice, location: location),
            );
          }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGuideCard(String name, String image, String location) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                ),
                Positioned(
                  bottom: 5,
                  left: 10,
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 10)),
                      ),
                      const SizedBox(width: 4),
                      const Text("127 Reviews", style: TextStyle(color: Colors.white, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: primaryColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourCard(String title, String image, String price, {String location = "Seeded Tour"}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(image, height: 130, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
                    ),
                    const SizedBox(width: 6),
                    const Text("1247 likes", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.favorite_border, color: primaryColor, size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.access_time, size: 12, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("3 days", style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Filters",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Segmented control implementation
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() => _isGuidesTab = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isGuidesTab ? primaryColor : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: _isGuidesTab ? null : Border.all(color: Colors.grey[200]!),
                              ),
                              child: Center(
                                child: Text(
                                  "Guides",
                                  style: TextStyle(
                                    color: _isGuidesTab ? Colors.white : Colors.black87,
                                    fontWeight: _isGuidesTab ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() => _isGuidesTab = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isGuidesTab ? primaryColor : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: !_isGuidesTab ? null : Border.all(color: Colors.grey[200]!),
                              ),
                              child: Center(
                                child: Text(
                                  "Tours",
                                  style: TextStyle(
                                    color: !_isGuidesTab ? Colors.white : Colors.black87,
                                    fontWeight: !_isGuidesTab ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Date Field
                  const Text("Date", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 10),
                      Text("mm/dd/yy", style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ],
                  ),
                  const Divider(height: 30),
                  
                  // Language Selection
                  const Text("Guide's Language", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildLanguageChip("Vietnamese", true),
                      _buildLanguageChip("English", false),
                      _buildLanguageChip("Korean", false),
                      _buildLanguageChip("Spanish", false),
                      _buildLanguageChip("French", false),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Fee Field
                  const Text("Fee", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.monetization_on_outlined, size: 16, color: Colors.grey),
                          SizedBox(width: 10),
                          Text("Fee", style: TextStyle(color: Colors.grey, fontSize: 15)),
                        ],
                      ),
                      const Text("(\$/hour)", style: TextStyle(color: Colors.black87, fontSize: 13)),
                    ],
                  ),
                  const Divider(height: 30),
                  
                  const Spacer(),
                  // Apply Filters Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text("APPLY FILTERS", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageChip(String lang, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? primaryColor : Colors.grey[300]!),
      ),
      child: Text(
        lang,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}

