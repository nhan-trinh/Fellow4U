import 'package:flutter/material.dart';
import 'package:Fellow4U/features/trips/payment_page.dart';

class TripDetailPage extends StatefulWidget {
  final String status; // 'current', 'confirmed', 'offers', 'waiting'
  const TripDetailPage({super.key, required this.status});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  String? _chosenOffer; // keep track of chosen guide for 'offers' status

  final List<Map<String, dynamic>> _offers = [
    {
      "name": "Khai Ho",
      "image": "assets/icons/khaiho.png",
      "reviews": 123,
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      "fee": "\$10/hour",
    },
    {
      "name": "Tran Thao",
      "image": "assets/icons/emmy.png",
      "reviews": 6,
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      "fee": "\$8/hour",
    },
    {
      "name": "Hennry",
      "image": "assets/icons/yoojin.png",
      "reviews": 79,
      "desc":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      "fee": "\$12/hour",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Trip Detail",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.status != 'current'
            ? [
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black),
                  onPressed: _showEditDeleteBottomSheet,
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),
            const SizedBox(height: 20),
            _buildTripInfoRow("Date", "Feb 2, 2020"),
            _buildTripInfoRow("Time", "8:00AM - 10:00AM"),
            if (widget.status != 'offers') ...[
              _buildTripInfoRow("Guide", "Emmy", isLink: true),
            ],
            _buildTripInfoRow("Number of Travelers", "2"),
            const SizedBox(height: 15),
            const Text(
              "Attractions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildAttractionsList(),
            const SizedBox(height: 20),
            _buildFeeRow(),
            const SizedBox(height: 20),
            _buildDynamicBottom(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage('assets/icons/hoguom.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 15,
          child: Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white, size: 14),
              SizedBox(width: 5),
              Text(
                "Hanoi, Vietnam",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Avatar processing
        Positioned(
          bottom: -25,
          right: 20,
          child: widget.status == 'offers'
              ? SizedBox(
                  width: 65,
                  height: 55,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: _buildAvatarCircle(
                          AssetImage('assets/icons/tuantran.png'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: _buildAvatarCircle(
                          null,
                          child: const Text(
                            "+3",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          bgColor: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildAvatarCircle(const AssetImage('assets/icons/emmy.png')),
        ),
      ],
    );
  }

  Widget _buildAvatarCircle(
    ImageProvider? img, {
    Widget? child,
    Color? bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: bgColor ?? Colors.white,
        backgroundImage: img,
        child: child,
      ),
    );
  }

  Widget _buildTripInfoRow(String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isLink ? primaryColor : Colors.grey[700],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionsList() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildLocationChip("Ho Guom"),
        _buildLocationChip("Ho Hoan Kiem"),
        _buildLocationChip("Pho 12 Pho Kim Ma"),
      ],
    );
  }

  Widget _buildLocationChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: primaryColor, size: 14),
          const SizedBox(width: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Fee",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "\$20.00",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicBottom() {
    switch (widget.status) {
      case 'current':
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check, size: 16),
              SizedBox(width: 8),
              Text("Mark Finished", style: TextStyle(fontSize: 13)),
            ],
          ),
        );
      case 'confirmed':
        return Row(
          children: [
            Expanded(
              child: _buildOutlineButton("Chat", Icons.chat_bubble_outline),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildOutlineButton(
                "Pay",
                Icons.credit_card,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 'waiting':
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Please wait a minute for your Guide to confirm",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        );
      case 'offers':
        return _buildOffersList();
      default:
        return Container();
    }
  }

  Widget _buildOutlineButton(
    String label,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primaryColor, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Offers",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ..._offers.map((offer) => _buildOfferItem(offer)).toList(),
      ],
    );
  }

  Widget _buildOfferItem(Map<String, dynamic> offer) {
    bool isChosen = _chosenOffer == offer['name'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 22, backgroundImage: AssetImage(offer['image'])),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      offer['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        if (isChosen)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  "Chosen",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              _showOfferOptionsBottomSheet(offer['name']),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
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
                    const SizedBox(width: 5),
                    Text(
                      "${offer['reviews']} Reviews",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  offer['desc'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Offer fee  ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      offer['fee'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOfferOptionsBottomSheet(String guideName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text("Chat with $guideName"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text("Choose $guideName"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _chosenOffer = guideName;
                  });
                },
              ),
              const Divider(),
              ListTile(
                title: const Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDeleteBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text("Edit This Trip"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text("Delete This Trip"),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDialog();
                },
              ),
              const Divider(),
              ListTile(
                title: const Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              "Delete This Trip",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this trip?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.only(bottom: 15),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                  context,
                ); // Close Trip detail and return to My Trips
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

