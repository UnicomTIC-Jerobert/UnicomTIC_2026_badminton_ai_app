enum FeedItemType { statusUpdate, flashSale, matchInvite }

class FeedItem {
  final String id;
  final FeedItemType type;
  final String authorName;
  final String timeAgo;
  final String content;
  final dynamic
  extraData; // Holds specific data like price, match percentage, etc.

  FeedItem({
    required this.id,
    required this.type,
    required this.authorName,
    required this.timeAgo,
    required this.content,
    this.extraData,
  });
}
