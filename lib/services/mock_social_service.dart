import '../models/feed_item.dart';

class MockSocialService {
  Future<List<FeedItem>> getFeed() async {
    // Simulate network loading
    await Future.delayed(const Duration(seconds: 1));

    return [
      FeedItem(
        id: '1',
        type: FeedItemType.statusUpdate,
        authorName: 'Dinesh K.',
        timeAgo: '10 mins ago',
        content: 'Just finished an amazing 2-hour session at Nallur Courts! The new synthetic mats are incredibly grippy. 🏸🔥',
      ),
      FeedItem(
        id: '2',
        type: FeedItemType.flashSale,
        authorName: 'System Bot (AI)',
        timeAgo: '1 hour ago',
        content: 'A group just cancelled! Court 1 at Jaffna Smashers is available right now.',
        extraData: {'originalPrice': '\$15', 'discountPrice': '\$7.50', 'time': '7:00 PM'},
      ),
      FeedItem(
        id: '3',
        type: FeedItemType.matchInvite,
        authorName: 'AI Matchmaker',
        timeAgo: '2 hours ago',
        content: 'You usually play on Thursdays. I found a player looking for a doubles partner with a similar skill level to yours.',
        extraData: {'playerName': 'Sanjay', 'skill': 'Intermediate', 'matchScore': '94% Match'},
      ),
    ];
  }
}