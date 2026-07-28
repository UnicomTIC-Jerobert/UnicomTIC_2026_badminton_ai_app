import 'package:flutter/material.dart';
import '../models/feed_item.dart';
import '../services/mock_social_service.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final MockSocialService _socialService = MockSocialService();
  late Future<List<FeedItem>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _socialService.getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Community Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // FAB for proactive Matchmaking!
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // This will eventually link to the AI Matchmaking chat flow
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Finding a partner for today...')),
          );
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: const Text(
          'Find Partner',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<FeedItem>>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading feed.'));
          }

          final feedItems = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: feedItems.length,
            itemBuilder: (context, index) {
              final item = feedItems[index];
              // THE POLYMORPHIC UI RENDERING
              switch (item.type) {
                case FeedItemType.statusUpdate:
                  return _buildStatusCard(item);
                case FeedItemType.flashSale:
                  return _buildFlashSaleCard(item);
                case FeedItemType.matchInvite:
                  return _buildMatchCard(item);
              }
            },
          );
        },
      ),
    );
  }

  // --- WIDGET 1: Standard Status Update ---
  Widget _buildStatusCard(FeedItem item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal[100],
                  child: Text(item.authorName[0]),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.content),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text('Like', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, color: Colors.grey[600], size: 20),
                const SizedBox(width: 4),
                Text('Comment', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET 2: Flash Sale (The No-Show Resolver) ---
  Widget _buildFlashSaleCard(FeedItem item) {
    return Card(
      color: Colors.orange[50], // Stand-out color
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  'FLASH SLOT AVAILABLE',
                  style: TextStyle(
                    color: Colors.deepOrange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.extraData['time'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          item.extraData['originalPrice'],
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.extraData['discountPrice'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Claim Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET 3: AI Matchmaking Recommendation ---
  Widget _buildMatchCard(FeedItem item) {
    return Card(
      color: Colors.teal[50],
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  'AI MATCH SUGGESTION',
                  style: TextStyle(
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.content),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(item.extraData['playerName'][0]),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.extraData['playerName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.extraData['skill'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.extraData['matchScore'],
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal),
                ),
                child: const Text('Send Play Invite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
