import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/mock_court_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockCourtService _courtService = MockCourtService();
  late Future<List<Court>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    // Trigger the mock API call when the screen loads
    _courtsFuture = _courtService.fetchNearbyCourts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Discover Courts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      // SingleChildScrollView allows the whole screen to scroll vertically
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMockMap(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Nearby Courts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildNearbyCourtsList(),
          ],
        ),
      ),
    );
  }

  // Widget 1: A placeholder for our future Google Maps integration
  Widget _buildMockMap() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 50, color: Colors.teal),
          SizedBox(height: 8),
          Text(
            'Interactive Map Loading...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget 2: The FutureBuilder that handles data loading
  Widget _buildNearbyCourtsList() {
    return FutureBuilder<List<Court>>(
      future: _courtsFuture,
      builder: (context, snapshot) {
        // State 1: Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          );
        }

        // State 2: Error
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading courts.'));
        }

        // State 3: Success
        final courts = snapshot.data!;
        return SizedBox(
          height: 180, // Fixed height for horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: courts.length,
            itemBuilder: (context, index) {
              return _buildCourtCard(courts[index]);
            },
          ),
        );
      },
    );
  }

  // Widget 3: The individual Court Card UI
  Widget _buildCourtCard(Court court) {
    return Container(
      width: 240, // Width of each card
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.sports_tennis, color: Colors.teal),
              Text(
                '${court.distanceKm} km',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(
            court.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Surface: ${court.surfaceType}',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${court.pricePerHour}/hr',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // In the future, this will navigate to the AI chat screen!
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
