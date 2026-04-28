import 'package:flutter/material.dart';
import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/trips/create_new_trip_page.dart';
import 'package:Fellow4U/features/trips/data/trips_service.dart';
import 'package:Fellow4U/features/trips/trip_detail_page.dart';
import 'package:Fellow4U/features/trips/payment_page.dart';
import 'package:Fellow4U/features/chat/chat_page.dart';
import 'package:Fellow4U/features/profile/profile_page.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  final TripsService _tripsService = TripsService();

  static const List<String> _statusByTab = [
    "current",
    "next",
    "past",
    "wishlist",
  ];

  static const Map<String, String> _fallbackImageByStatus = {
    "current": "assets/icons/trip2.png",
    "next": "assets/icons/hoguom.png",
    "past": "assets/icons/quoctugiam.png",
    "wishlist": "assets/icons/mb.png",
  };

  int _selectedTab = 0;
  bool _isLoadingTrips = false;
  String? _tripError;
  final Map<String, List<Map<String, dynamic>>> _tripCacheByStatus = {};

  @override
  void initState() {
    super.initState();
    _loadTripsForSelectedTab();
  }

  String get _currentStatus => _statusByTab[_selectedTab];

  Future<void> _loadTripsForSelectedTab({bool force = false}) async {
    final status = _currentStatus;
    if (!force && _tripCacheByStatus.containsKey(status)) return;

    setState(() {
      _isLoadingTrips = true;
      _tripError = null;
    });
    try {
      final trips = await _tripsService.getMyTrips(status: status);
      if (!mounted) return;
      setState(() {
        _tripCacheByStatus[status] = trips.map(_mapTripForUi).toList();
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _tripError = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTrips = false;
        });
      }
    }
  }

  Map<String, dynamic> _mapTripForUi(Map<String, dynamic> raw) {
    final status = raw["status"]?.toString() ?? "next";
    final startDate = DateTime.tryParse(raw["startDate"]?.toString() ?? "");
    final endDate = DateTime.tryParse(raw["endDate"]?.toString() ?? "");
    final date = startDate == null
        ? "N/A"
        : "${_monthName(startDate.month)} ${startDate.day}, ${startDate.year}";
    final time = (startDate != null && endDate != null)
        ? "${_twoDigits(startDate.hour)}:${_twoDigits(startDate.minute)} - ${_twoDigits(endDate.hour)}:${_twoDigits(endDate.minute)}"
        : "N/A";
    final totalPrice = raw["totalPrice"];
    final num? priceNum = totalPrice is num
        ? totalPrice
        : num.tryParse(totalPrice?.toString() ?? "");
    return {
      ...raw,
      "tripId": raw["_id"]?.toString() ?? "",
      "title": raw["title"]?.toString() ?? "Untitled Trip",
      "location": raw["location"]?.toString() ?? "Unknown location",
      "date": date,
      "time": time,
      "guide": "Guide TBD",
      "guideImage": "assets/icons/tuantran.png",
      "statusText": status == "wishlist" ? "Wish list item" : "Waiting for offers",
      "status": status == "next" ? "normal" : status,
      "uiStatus": status,
      "image": _fallbackImageByStatus[status] ?? "assets/icons/trip2.png",
      "days": startDate != null && endDate != null
          ? "${endDate.difference(startDate).inDays.abs() + 1} days"
          : "1 day",
      "price": "\$${(priceNum ?? 0).toStringAsFixed(2)}",
    };
  }

  String _twoDigits(int value) => value.toString().padLeft(2, "0");

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return month >= 1 && month <= 12 ? months[month - 1] : "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(child: _buildTabBar()),
          SliverToBoxAdapter(child: const SizedBox(height: 10)),
          _buildTabContent(),
          SliverToBoxAdapter(
            child: const SizedBox(
              height: 80,
            ), // Padding for floating button and nav
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNewTripPage()),
          );
          if (created == true) {
            _tripCacheByStatus.clear();
            _loadTripsForSelectedTab(force: true);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false, // hide back button for tabs
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/dn1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.4)),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Trips",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ["Current Trips", "Next Trips", "Past Trips", "Wish List"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
                _loadTripsForSelectedTab();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == index ? primaryColor : Colors.white,
                  border: _selectedTab == index
                      ? null
                      : Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: _selectedTab == index
                        ? Colors.white
                        : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_isLoadingTrips) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_tripError != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Text(
                _tripError!,
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _loadTripsForSelectedTab(force: true),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final trips = _tripCacheByStatus[_currentStatus] ?? [];
    if (trips.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              "No ${_currentStatus.toUpperCase()} trips yet",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      );
    }

    if (_currentStatus == "wishlist") {
      return _buildWishList(trips);
    }

    return _buildTripsList(
      trips,
      isCurrent: _currentStatus == "current",
      isNext: _currentStatus == "next",
      isPast: _currentStatus == "past",
    );
  }

  Widget _buildTripsList(
    List<Map<String, dynamic>> trips, {
    bool isCurrent = false,
    bool isNext = false,
    bool isPast = false,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final trip = trips[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Image Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.asset(
                          trip['image'],
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Dark Overlay
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      // Mark Finished (Current)
                      if (isCurrent)
                        Positioned(
                          top: 15,
                          left: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Mark Finished",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Top Right Icon (Options)
                      if (isNext || isPast)
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.white.withOpacity(0.8),
                            size: 28,
                          ),
                        ),
                      // Top Left Tags (Visiting or Bidding for Next Trips)
                      if (isNext && trip['status'] == 'visiting')
                        _buildImageTag(
                          "Visiting",
                          Colors.grey.withOpacity(0.8),
                        ),
                      if (isNext && trip['status'] == 'bidding')
                        _buildImageTag("Bidding", Colors.grey.withOpacity(0.8)),

                      // Location Bottom Left
                      Positioned(
                        bottom: 12,
                        left: 15,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              trip['location'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Info Section
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildIconText(Icons.calendar_today, trip['date']),
                                  const SizedBox(height: 6),
                                  _buildIconText(Icons.access_time, trip['time']),
                                  const SizedBox(height: 6),
                                  if (trip['guide'] != null)
                                    _buildIconText(Icons.person, trip['guide'])
                                  else if (trip['statusText'] != null)
                                    _buildIconText(
                                      Icons.person,
                                      trip['statusText'],
                                      isAlert: trip['status'] == 'rejected',
                                    ),
                                ],
                              ),
                            ),
                            // Avatar
                            if (trip['status'] == 'rejected')
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: primaryColor,
                                ),
                              )
                            else if (trip['status'] == 'bidding')
                              SizedBox(
                                width: 55,
                                height: 45,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundImage: AssetImage(
                                          trip['guideImage'],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.black87,
                                        child: const Text(
                                          "+3",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage(
                                  trip['guideImage']?.toString() ??
                                      "assets/icons/tuantran.png",
                                ),
                              ),
                          ],
                        ),

                        // Action Buttons
                        if (isCurrent || isNext) ...[
                          const SizedBox(height: 15),
                          _buildActionButtons(context, trip, isCurrent),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: trips.length),
      ),
    );
  }

  Widget _buildImageTag(String text, Color background) {
    return Positioned(
      top: 15,
      left: 15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, {bool isAlert = false}) {
    return Row(
      children: [
        Icon(
          isAlert ? Icons.info_outline : icon,
          size: 14,
          color: isAlert ? Colors.red : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isAlert ? Colors.red : Colors.grey[700],
            fontSize: 12,
            fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Map<String, dynamic> trip,
    bool isCurrent,
  ) {
    final status = trip['status']?.toString();
    final tripId = trip['tripId']?.toString() ?? "";

    Future<void> openDetail(String detailStatus) async {
      if (tripId.isEmpty) return;
      final changed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TripDetailPage(tripId: tripId, status: detailStatus),
        ),
      );
      if (changed == true) {
        _tripCacheByStatus.remove(_currentStatus);
        _loadTripsForSelectedTab(force: true);
      }
    }

    if (status == 'visiting') {
      return SizedBox(
        width: 100,
        height: 36,
        child: _buildOutlineButton(
          "Detail",
          Icons.info_outline,
          onTap: () => openDetail('waiting'),
        ),
      );
    } else if (status == 'bidding') {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: _buildOutlineButton(
                "Detail",
                Icons.info_outline,
                onTap: () => openDetail('offers'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 36,
              child: _buildOutlineButton("Chat", Icons.chat_bubble_outline),
            ),
          ),
        ],
      );
    } else if (status == 'rejected') {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 36,
              child: _buildOutlineButton(
                "Detail",
                Icons.info_outline,
                onTap: () => openDetail('waiting'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: const Text(
                  "Choose another Guide",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Current or Normal Next
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: _buildOutlineButton(
                "Detail",
                Icons.info_outline,
                onTap: () => openDetail(isCurrent ? 'current' : 'confirmed'),
              ),
            ),
          ),
          if (status != null && !isCurrent) ...[
            // meaning isNext normal
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 36,
                child: _buildOutlineButton("Chat", Icons.chat_bubble_outline),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 36,
                child: _buildOutlineButton(
                  "Pay",
                  Icons.credit_card,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PaymentPage()),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      );
    }
  }

  OutlinedButton _buildOutlineButton(
    String label,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.zero,
      ),
      onPressed: onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primaryColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishList(List<Map<String, dynamic>> wishListTours) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final tour = wishListTours[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.asset(
                          tour['image'],
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
                          child: const Icon(
                            Icons.bookmark,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "1247 likes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                tour['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              color: primaryColor,
                              size: 18,
                            ),
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
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tour['date'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tour['days'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              tour['price'],
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: wishListTours.length),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: true,
      elevation: 20,
      currentIndex: 1, // Focus on My Trips
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: "My Trips",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Notify",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}

