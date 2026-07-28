import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/mock_user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MockUserService _userService = MockUserService();
  late Future<UserProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _userService.getUserProfile();
  }

  // --- THE AI NEGOTIATION DIALOG ---
  // Teach freshers how to show popups and handle user decisions
  void _triggerAIResellFlow(BuildContext context, UpcomingBooking booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.smart_toy, color: Colors.teal),
              const SizedBox(width: 8),
              const Text('Smart Cancel'),
            ],
          ),
          content: Text(
            "You paid \$${booking.amountPaid} for ${booking.courtName} at ${booking.time}.\n\n"
            "If you cancel now, I can broadcast this slot to the waitlist as a Flash Sale. "
            "If someone claims it, I will refund 50% directly to your Wallet. Proceed?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Nevermind',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('AI is attempting to resell your slot!'),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Resell It'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile.'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(user),
                _buildWalletCard(user),
                _buildBookingsList(user, context),
              ],
            ),
          );
        },
      ),
    );
  }

  // WIDGET 1: User Header
  Widget _buildHeader(UserProfile user) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.teal[100],
            child: Text(
              user.profileImageUrl,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.skillLevel,
              style: TextStyle(color: Colors.grey[800], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET 2: The Digital Wallet
  Widget _buildWalletCard(UserProfile user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Color(0xFF004D40)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${user.walletBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Top Up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET 3: Upcoming Bookings List
  Widget _buildBookingsList(UserProfile user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Bookings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // We use shrinkWrap: true because this ListView is inside a SingleChildScrollView
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: user.upcomingBookings.length,
            itemBuilder: (context, index) {
              final booking = user.upcomingBookings[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.courtName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.date} • ${booking.time}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              _triggerAIResellFlow(context, booking),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red[400],
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                          child: const Text("Can't make it? (Smart Cancel)"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
